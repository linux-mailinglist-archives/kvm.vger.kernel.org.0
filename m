Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB627136AAD
	for <lists+kvm@lfdr.de>; Fri, 10 Jan 2020 11:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727503AbgAJKKy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jan 2020 05:10:54 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49529 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727352AbgAJKKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jan 2020 05:10:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578651052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=+384Z2dFoBu9nsPZe4I7aU3LpFOh/q5c7y1eCLwiNX8=;
        b=IVWGRZ6QMaobDRApHauWmy9mKKuhSArwVwy9W8j9l1YuhFnmBke9/r6sywtPO6av/NIHJO
        7rgVpJJXwMoyF33NC6S0fq8oloTEXNoM8UF/kK41eHCV0pqjkkCm+p3cDL17/THVdV2U47
        4mJgJcoNZabviIO85CoUATr9i3Xeqvw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-OfJRqet3M3eAITAvHe0e_Q-1; Fri, 10 Jan 2020 05:10:49 -0500
X-MC-Unique: OfJRqet3M3eAITAvHe0e_Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9CFEB18B5FB4;
        Fri, 10 Jan 2020 10:10:48 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-154.ams2.redhat.com [10.36.116.154])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4B0237BA51;
        Fri, 10 Jan 2020 10:10:44 +0000 (UTC)
Subject: Re: [PATCH v5] KVM: s390: Add new reset vcpu API
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     borntraeger@de.ibm.com, linux-s390@vger.kernel.org,
        david@redhat.com, cohuck@redhat.com
References: <20200110094659.4118-1-frankja@linux.ibm.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <ecd8da3a-5232-6074-f123-196f744a8ba6@redhat.com>
Date:   Fri, 10 Jan 2020 11:10:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200110094659.4118-1-frankja@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/01/2020 10.46, Janosch Frank wrote:
> The architecture states that we need to reset local IRQs for all CPU
> resets. Because the old reset interface did not support the normal CPU
> reset we never did that on a normal reset.
> 
> Let's implement an interface for the missing normal and clear resets
> and reset all local IRQs, registers and control structures as stated
> in the architecture.
> 
> Userspace might already reset the registers via the vcpu run struct,
> but as we need the interface for the interrupt clearing part anyway,
> we implement the resets fully and don't rely on userspace to reset the
> rest.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  Documentation/virt/kvm/api.txt |  45 +++++++++++++
>  arch/s390/kvm/kvm-s390.c       | 111 +++++++++++++++++++++++----------
>  include/uapi/linux/kvm.h       |   5 ++
>  3 files changed, 127 insertions(+), 34 deletions(-)
> 
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index ebb37b34dcfc..5203d95b1a21 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -4168,6 +4168,44 @@ This ioctl issues an ultravisor call to terminate the secure guest,
>  unpins the VPA pages and releases all the device pages that are used to
>  track the secure pages by hypervisor.
>  
> +4.122 KVM_S390_NORMAL_RESET
> +
> +Capability: KVM_CAP_S390_VCPU_RESETS
> +Architectures: s390
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0
> +
> +This ioctl resets VCPU registers and control structures according to
> +the cpu reset definition in the POP (Principles Of Operation).
> +
> +4.123 KVM_S390_INITIAL_RESET
> +
> +Capability: none
> +Architectures: s390
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0
> +
> +This ioctl resets VCPU registers and control structures according to
> +the initial cpu reset definition in the POP (Principles Of
> +Operation).

Nit: You "defined" POP already in the NORMAL_RESET section, so I'd
either only use the abbreviation here, or spell it out completely, but
not both again.

> However, the cpu is not put into ESA mode. This reset is a
> +superset of the normal reset.
> +
> +4.124 KVM_S390_CLEAR_RESET
> +
> +Capability: KVM_CAP_S390_VCPU_RESETS
> +Architectures: s390
> +Type: vcpu ioctl
> +Parameters: none
> +Returns: 0
> +
> +This ioctl resets VCPU registers and control structures according to
> +the clear cpu reset definition in the POP (Principles Of Operation).

dito

 Thomas

