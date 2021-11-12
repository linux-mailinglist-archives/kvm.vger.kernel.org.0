Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC3E44E3EA
	for <lists+kvm@lfdr.de>; Fri, 12 Nov 2021 10:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234730AbhKLJjF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Nov 2021 04:39:05 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:45331 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234775AbhKLJjE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 12 Nov 2021 04:39:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636709773;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iddMIYdkDaFmGr4lSQ8FW8kjIqoE80Tt/hNuD+cPMhk=;
        b=FcI9xYbUff+IQYYiDAw0M2J+irZd2v34lx/iwOlyzt8VdUbpPkA1aPOHHfqGKbl7RbT/z8
        /aAPS99jgwyYwGf7EYZ3Auhzu2mi1InGTNjrfQrNJqF9pUqukzz97IjUc/GnACleAqUSob
        Hv36aYImW2VJ0fahnCqmTGxwlZj2zEY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-GM2N1llAPdu_mJjTF0ICOQ-1; Fri, 12 Nov 2021 04:36:10 -0500
X-MC-Unique: GM2N1llAPdu_mJjTF0ICOQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17EACED2ED;
        Fri, 12 Nov 2021 09:35:29 +0000 (UTC)
Received: from [10.39.193.118] (unknown [10.39.193.118])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 28CDD5D6D7;
        Fri, 12 Nov 2021 09:35:23 +0000 (UTC)
Message-ID: <ea64e454-17c3-374b-67a1-f382cdf6c6a6@redhat.com>
Date:   Fri, 12 Nov 2021 10:35:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 4/7] KVM: SEV: Add support for SEV intra host migration
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pgonda@google.com, seanjc@google.com,
        Marc Orr <marcorr@google.com>,
        David Rientjes <rientjes@google.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>
References: <20211111154930.3603189-1-pbonzini@redhat.com>
 <20211111154930.3603189-5-pbonzini@redhat.com>
In-Reply-To: <20211111154930.3603189-5-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/11/21 16:49, Paolo Bonzini wrote:
> +out_dst_cgroup:
> +	if (ret < 0) {
> +		sev_misc_cg_uncharge(dst_sev);
> +out_dst_put_cgroup:
> +		put_misc_cg(dst_sev->misc_cg);
> +		dst_sev->misc_cg = NULL;
> +	}

Wrong (you must not uncharge if the dst_sev and src_sev cgroup are the 
same)  _and_ unnecessarily complicated.

I'll send an 8/7 patch as a fixup.

Paolo

