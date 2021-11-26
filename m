Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D092445EDF6
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 13:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348618AbhKZMh5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 07:37:57 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58898 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1377501AbhKZMf4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 26 Nov 2021 07:35:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637929963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rPcwEb0aos/cKQGiDtaX8d59R5gkrhAy08qwsxfXh4Y=;
        b=Yr5dxxFWTopLob0zzAid1mZSgcYSCDOzQOEOOkRKT+vZJt2bn8de4j5aU4vWjSSmwKdZmZ
        /cdYOqDD0W6qObTnnPjSn4ZRe5ynU2kyi3LgJUlOtTv6t88P1lCCSnKRqP+j7AAuaCY3wk
        DGFuYwejGflP4O4/HsTvFWwHsvgE2SY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-58DHABfiOceuQUZBB1UdAg-1; Fri, 26 Nov 2021 07:32:38 -0500
X-MC-Unique: 58DHABfiOceuQUZBB1UdAg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2C3D11926DA0;
        Fri, 26 Nov 2021 12:32:37 +0000 (UTC)
Received: from [10.39.195.16] (unknown [10.39.195.16])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AEED5F4EF;
        Fri, 26 Nov 2021 12:32:35 +0000 (UTC)
Message-ID: <54225ff0-b90a-6c1f-f474-2338df21befa@redhat.com>
Date:   Fri, 26 Nov 2021 13:32:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2] KVM: selftests: Make sure kvm_create_max_vcpus test
 won't hit RLIMIT_NOFILE
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>, linux-kernel@vger.kernel.org
References: <20211123135953.667434-1-vkuznets@redhat.com>
 <YZ6JWGCaDihh4KoG@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YZ6JWGCaDihh4KoG@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/24/21 19:50, Sean Christopherson wrote:
>> +	if (rl.rlim_cur < nr_fds_wanted) {
>> +		rl.rlim_cur = nr_fds_wanted;
>> +
>> +		if (rl.rlim_max <  nr_fds_wanted)
>> +			rl.rlim_max = nr_fds_wanted;
> Nit, this could use max().

If the hard limit is too low, the right thing to do is to skip the test:

--- a/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
+++ b/tools/testing/selftests/kvm/kvm_create_max_vcpus.c
@@ -59,11 +59,19 @@ int main(int argc, char *argv[])
  
  	if (rl.rlim_cur < nr_fds_wanted) {
  		rl.rlim_cur = nr_fds_wanted;
-
-		if (rl.rlim_max <  nr_fds_wanted)
+		if (rl.rlim_max < nr_fds_wanted) {
+			int old_rlim_max = rl.rlim_max;
  			rl.rlim_max = nr_fds_wanted;
  
-		TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &rl), "setrlimit() failed!");
+			int r = setrlimit(RLIMIT_NOFILE, &rl);
+			if (r < 0) {
+				printf("RLIMIT_NOFILE hard limit is too low (%d, wanted %d)\n",
+				       old_rlim_max, nr_fds_wanted);
+				exit(KSFT_SKIP);
+			}
+		} else {
+			TEST_ASSERT(!setrlimit(RLIMIT_NOFILE, &rl), "setrlimit() failed!");
+		}
  	}
  
  	/*

Nevertheless, thanks for the fix and the review! (I might have missed it
if it wasn't for your remark).

Paolo
> Reviewed-and-tested-by: Sean Christopherson<seanjc@google.com>  
> 

