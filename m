Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD4FB1C992B
	for <lists+kvm@lfdr.de>; Thu,  7 May 2020 20:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728098AbgEGSW2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 May 2020 14:22:28 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31852 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726367AbgEGSW2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 May 2020 14:22:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588875746;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uY7dbQBmsUoAzmKGSYRJNZ21+7owwaWmUZw/eXb9gjM=;
        b=F82e2qyYhONLSEbuO63WFstwg/Sa+EwwQnZ8qPm5xt6JY7dFsp2GNbzyiQl1wz63f4q5do
        69mU1hpCPSH218Nvuw2wQdVmTg6FGyDIi/bxZkD5VMurhlZ4mLyHmgqvfQ+Yt7bb4TU1Pl
        x9xMeDM7oF3TmTI82iuBtqfY7i46oH8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-186-mE5_Yw-WN_qSqMu4OJ7Jng-1; Thu, 07 May 2020 14:22:23 -0400
X-MC-Unique: mE5_Yw-WN_qSqMu4OJ7Jng-1
Received: by mail-qk1-f199.google.com with SMTP id d19so6658267qkj.21
        for <kvm@vger.kernel.org>; Thu, 07 May 2020 11:22:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uY7dbQBmsUoAzmKGSYRJNZ21+7owwaWmUZw/eXb9gjM=;
        b=BYIcMd3ibD5K79xyMXpxyP6OUkBI4cwaHlLLYrszQZKfByFGxsmdnJ9N9NaCA85C0O
         /4FasIESkn/jKYAUb4wlHf0MBJBNT9+1apTtkKFQgEMMPEeZNgkPWUDObNTEDEIe3fp3
         lnL4k0MB+7MOScyottjed/H5B0cXfB51Qa7qxgSlzQIvBdprCBTOVdiwg27Q0QtClsAu
         /2NNYTy9L0vhHBjIEYoTBDUpCvp/xMXGmzLvctAEqgdvGZK13dreWfyHo5Mf1auReBKx
         fp8//uQJ3VKDtuZjJncO89fE/O+wmApuHCPOzsiT8ilVL+2sqeLh8bBL1CewYVUCOHuK
         EodA==
X-Gm-Message-State: AGi0Pua401/xv8ZRwSl06FO/O3gGWfnKgjDcqbN/07ZlNGpcB6gMVCl1
        DDS6yNfxz054jnXmo9yHWHmhYVElAZT0xaDl2KrUBIuDm8o+UnSPo6Vl5pqIlTkjbHto3VltVyZ
        9/4vnY8gC5ovb
X-Received: by 2002:a05:620a:3c5:: with SMTP id r5mr16131927qkm.138.1588875742718;
        Thu, 07 May 2020 11:22:22 -0700 (PDT)
X-Google-Smtp-Source: APiQypJtNBFACRv+C675BBmb3U5pDjlBVo0aQUE1Kz2y73CScdi8+R9TWP79HmHhMhLl2mdB+odeyQ==
X-Received: by 2002:a05:620a:3c5:: with SMTP id r5mr16131906qkm.138.1588875742430;
        Thu, 07 May 2020 11:22:22 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id y3sm4857000qkc.4.2020.05.07.11.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2020 11:22:21 -0700 (PDT)
Date:   Thu, 7 May 2020 14:22:20 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 7/9] KVM: SVM: keep DR6 synchronized with
 vcpu->arch.dr6
Message-ID: <20200507182220.GI228260@xz-x1>
References: <20200507115011.494562-1-pbonzini@redhat.com>
 <20200507115011.494562-8-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200507115011.494562-8-pbonzini@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 07, 2020 at 07:50:09AM -0400, Paolo Bonzini wrote:
> @@ -267,7 +268,7 @@ void enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
>  	svm->vmcb->save.rsp = nested_vmcb->save.rsp;
>  	svm->vmcb->save.rip = nested_vmcb->save.rip;
>  	svm->vmcb->save.dr7 = nested_vmcb->save.dr7;
> -	svm->vmcb->save.dr6 = nested_vmcb->save.dr6;
> +	svm->vcpu.arch.dr6  = nested_vmcb->save.dr6;

The rest looks very sane to me, but here I failed to figure out how arch.dr6
finally applied to save.dr6.  I saw it is applied in svm_vcpu_run() in the next
patch, but if that's the case then iiuc this commit may break bisection. Thanks,

-- 
Peter Xu

