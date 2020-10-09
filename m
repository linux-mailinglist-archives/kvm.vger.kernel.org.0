Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013662888C3
	for <lists+kvm@lfdr.de>; Fri,  9 Oct 2020 14:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387411AbgJIMb5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Oct 2020 08:31:57 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29150 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726501AbgJIMb5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 9 Oct 2020 08:31:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602246715;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6yZ9l/rYX1Gt+CSni2U2g8W0CJRek8YcNXwgHxtmpF4=;
        b=VBgd33y8hUXh4sPN4wE57voM5hAt5rEVNEwTRlmPZ6ShcoAFMQgDElB8G9gCOBKBEFvIDq
        7a3fTw15FVhdJahHs6OQAJniup34j9clGrXy9tbSRQtRKGj4zvCuEj7+y9N+ZZEMClkehF
        NhlUlIOA+OCstojvvdQ0SoWMDP5OfeE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-31-Pd7Sy1pPOrKh2toMQQRikw-1; Fri, 09 Oct 2020 08:31:53 -0400
X-MC-Unique: Pd7Sy1pPOrKh2toMQQRikw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B8757425FC;
        Fri,  9 Oct 2020 12:31:52 +0000 (UTC)
Received: from localhost.localdomain (ovpn-114-62.rdu2.redhat.com [10.10.114.62])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F28EC109516B;
        Fri,  9 Oct 2020 12:31:50 +0000 (UTC)
Subject: Re: [PATCH] KVM: SVM: Use a separate vmcb for the nested L2 guest
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     vkuznets@redhat.com, wei.huang2@amd.com
References: <20200917192306.2080-1-cavery@redhat.com>
 <587d1da1a037dd3ab7844c5cacc50bfda5ce6021.camel@redhat.com>
 <aaaadb29-6299-5537-47a9-072ca34ba512@redhat.com>
 <0007205290de75f04f5f2a92b891815438fd2f2f.camel@redhat.com>
From:   Cathy Avery <cavery@redhat.com>
Message-ID: <5849a6ae-30c3-95f2-6d97-80dcb66022c1@redhat.com>
Date:   Fri, 9 Oct 2020 08:31:49 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <0007205290de75f04f5f2a92b891815438fd2f2f.camel@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/8/20 6:23 AM, Maxim Levitsky wrote:
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index 0a06e62010d8c..7293ba23b3cbc 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -436,6 +436,9 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>          WARN_ON(svm->vmcb == svm->nested.vmcb02);
>   
>          svm->nested.vmcb02->control = svm->vmcb01->control;
> +
> +       nested_svm_vmloadsave(svm->vmcb01, svm->nested.vmcb02);
> +
>          svm->vmcb = svm->nested.vmcb02;
>          svm->vmcb_pa = svm->nested.vmcb02_pa;
>          load_nested_vmcb_control(svm, &nested_vmcb->control);
> @@ -622,6 +625,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>          if (svm->vmcb01->control.asid == 0)
>                  svm->vmcb01->control.asid = svm->nested.vmcb02->control.asid;
>   
> +       nested_svm_vmloadsave(svm->nested.vmcb02, svm->vmcb01);
>          svm->vmcb = svm->vmcb01;
>          svm->vmcb_pa = svm->nested.vmcb01_pa;
>   
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index b66239b26885d..ee9f87fe611f2 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1097,6 +1097,7 @@ static void init_vmcb(struct vcpu_svm *svm)
>                  clr_cr_intercept(svm, INTERCEPT_CR3_READ);
>                  clr_cr_intercept(svm, INTERCEPT_CR3_WRITE);
>                  save->g_pat = svm->vcpu.arch.pat;
> +               svm->nested.vmcb02->save.g_pat = svm->vcpu.arch.pat;
>                  save->cr3 = 0;
>                  save->cr4 = 0;
>          }

OK this worked for me. Thanks!

