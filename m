Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8447765072
	for <lists+kvm@lfdr.de>; Thu, 27 Jul 2023 11:57:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbjG0J5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jul 2023 05:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233216AbjG0J5C (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jul 2023 05:57:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5688B1B8
        for <kvm@vger.kernel.org>; Thu, 27 Jul 2023 02:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690451754;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7Et2+usQK1JlDG0GanNGbBu0x99mo/WvwuZuG01uDXE=;
        b=bJ/o5qNJKJVYlVOedhiuob13/ZsfP4GqKXPle4TQSH18Z2rsuD8uhqBJdbdkQ5Lc9rE3Cj
        ngDZyUt3lS+RM9BUfdHxUhvnzJGEnXUkrxizn9biHmISWuOkr4gvANXH1+/6JN96bZ2JZ9
        pX/ANYEwz01vmwpA0eZZuO6kYW+ENt4=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-531-dlBDvexKM1KbwVfNG8FutA-1; Thu, 27 Jul 2023 05:55:52 -0400
X-MC-Unique: dlBDvexKM1KbwVfNG8FutA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 09ADD3C11CC0;
        Thu, 27 Jul 2023 09:55:52 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C455740C2063;
        Thu, 27 Jul 2023 09:55:51 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Gavin Shan <gshan@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org
Subject: Re: [PATCH for-8.2 2/2] arm/kvm: convert to kvm_get_one_reg
In-Reply-To: <4a990b57-800c-6799-8c23-4488069ffb76@redhat.com>
Organization: Red Hat GmbH
References: <20230718111404.23479-1-cohuck@redhat.com>
 <20230718111404.23479-3-cohuck@redhat.com>
 <db578c20-22d9-3b76-63e7-d99b891f6d36@redhat.com>
 <878rb5g0f0.fsf@redhat.com>
 <4a990b57-800c-6799-8c23-4488069ffb76@redhat.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 27 Jul 2023 11:55:50 +0200
Message-ID: <875y6565ll.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 25 2023, Gavin Shan <gshan@redhat.com> wrote:

> On 7/24/23 18:48, Cornelia Huck wrote:
>> On Mon, Jul 24 2023, Gavin Shan <gshan@redhat.com> wrote:
>>>
>>> On 7/18/23 21:14, Cornelia Huck wrote:
>>>> We can neaten the code by switching the callers that work on a
>>>> CPUstate to the kvm_get_one_reg function.
>>>>
>>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>>> ---
>>>>    target/arm/kvm.c   | 15 +++---------
>>>>    target/arm/kvm64.c | 57 ++++++++++++----------------------------------
>>>>    2 files changed, 18 insertions(+), 54 deletions(-)
>>>>
>>>
>>> The replacements look good to me. However, I guess it's worty to apply
>>> the same replacements for target/arm/kvm64.c since we're here?
>>>
>>> [gshan@gshan arm]$ pwd
>>> /home/gshan/sandbox/q/target/arm
>>> [gshan@gshan arm]$ git grep KVM_GET_ONE_REG
>>> kvm64.c:    err = ioctl(fd, KVM_GET_ONE_REG, &idreg);
>>> kvm64.c:    return ioctl(fd, KVM_GET_ONE_REG, &idreg);
>>> kvm64.c:        ret = ioctl(fdarray[2], KVM_GET_ONE_REG, &reg);
>> 
>> These are the callers that don't work on a CPUState (all in initial
>> feature discovery IIRC), so they need to stay that way.
>> 
>
> Right, All these ioctl commands are issued when CPUState isn't around. However, there
> are two wrappers read_sys_{reg32, reg64}(). The ioctl call in kvm_arm_sve_get_vls()
> can be replaced by read_sys_reg64(). I guess it'd better to do this in a separate
> patch if you agree.

Yes, we could do that, but I'm not sure how much it adds to the
code... in any case, I agree that this would be a separate patch.

