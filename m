Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E48833CF8A8
	for <lists+kvm@lfdr.de>; Tue, 20 Jul 2021 13:13:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbhGTKcw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Jul 2021 06:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbhGTKcr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Jul 2021 06:32:47 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73423C061574
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 04:13:25 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id d2so25622504wrn.0
        for <kvm@vger.kernel.org>; Tue, 20 Jul 2021 04:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rssW9MvuSrY18dvpw7amkf+MYjvhgV8BCmj8r2D+edQ=;
        b=K7vq3dVJv9e19grP2qCy6RAOZY+bX+Abe2GwleQgCAThD/Ktphh7T6Hk8e+U7dOn5Q
         ymRWUaww5B0nvzeT//Q1p6BowVr0oYbwsyreIyOlK5N8DlZfrIu1zZ9o2opKWlKnBrnk
         LUCsiCUbO1X92FsH9QqgOFn2KjjXTQLsmYrpMUzxGFAZ/jOUz4jDfZzKO9QRDCm+1dEQ
         GVPLQBeAySBxe19MQruR5u16/OFBNBl8de3UVr0Z42Ef1FQxlvPify25KeQg4iRdsigB
         Lo4yVb2io4tvTVln2XGFG39wJoQ/PpjT9OhOUm+uJojX6OCXNmOmMF/3IjDmn6neevRp
         om0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rssW9MvuSrY18dvpw7amkf+MYjvhgV8BCmj8r2D+edQ=;
        b=GcThxpDz1XtMAqxmvMkg0hBuIK+VbSPCS1G498k2vmP3hQ2v+awLKVGJ80jb4dELhn
         NXFFRi2K8af9Ua4VJ/EfnxZ6AOR0dfIzdECzxtuB4OJE/ZgmzCKi6ILj3ag7ypQ24r+4
         eilIacZ4RXExG6XkbLjeQNdk/vsR1NjlPrpBAXb4oxk6C3LzpawGlyI0A7+XOVcVqjnb
         rjNU00JAaCdRiOZCiVbhD8ADkRhMO3dhp/CLYSSqm4mrdT/Op++sugTwxwLqtrrGKBiD
         WaPEKsj2ESM78Fcy6JkWg4mT94/MsPm2qGye79OnAsrzUILB+mHsDLtTsWf8BdF78g86
         Nitw==
X-Gm-Message-State: AOAM533v+09fOSG6SuH1ZujjCzkFLn5odqHYwK+GPGE5Q7CCvA21ChqB
        wirKBuCEMjcWSg31nphCZtFKkg==
X-Google-Smtp-Source: ABdhPJxucLoq3tJ6ywks6cNiyi6pYtOe5W3MkGbCfwenZlNTGXHtenBEwmkjoTj+HN+TgHpbImyIYQ==
X-Received: by 2002:adf:f74f:: with SMTP id z15mr35360657wrp.54.1626779603785;
        Tue, 20 Jul 2021 04:13:23 -0700 (PDT)
Received: from google.com ([2a00:79e0:d:210:83e0:11ac:c870:2b97])
        by smtp.gmail.com with ESMTPSA id y3sm23651964wrh.16.2021.07.20.04.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 04:13:23 -0700 (PDT)
Date:   Tue, 20 Jul 2021 12:13:20 +0100
From:   Quentin Perret <qperret@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org, will@kernel.org,
        dbrazdil@google.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
        Shanker R Donthineni <sdonthineni@nvidia.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        kernel-team@android.com
Subject: Re: [PATCH 04/16] KVM: arm64: Add MMIO checking infrastructure
Message-ID: <YPav0Hye5Dat/yoL@google.com>
References: <20210715163159.1480168-1-maz@kernel.org>
 <20210715163159.1480168-5-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210715163159.1480168-5-maz@kernel.org>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thursday 15 Jul 2021 at 17:31:47 (+0100), Marc Zyngier wrote:
> +struct s2_walk_data {
> +	kvm_pte_t	pteval;
> +	u32		level;
> +};
> +
> +static int s2_walker(u64 addr, u64 end, u32 level, kvm_pte_t *ptep,
> +		     enum kvm_pgtable_walk_flags flag, void * const arg)
> +{
> +	struct s2_walk_data *data = arg;
> +
> +	data->level = level;
> +	data->pteval = *ptep;
> +	return 0;
> +}
> +
> +/* Assumes mmu_lock taken */
> +static bool __check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
> +{
> +	struct s2_walk_data data;
> +	struct kvm_pgtable_walker walker = {
> +		.cb             = s2_walker,
> +		.flags          = KVM_PGTABLE_WALK_LEAF,
> +		.arg            = &data,
> +	};
> +
> +	kvm_pgtable_walk(vcpu->arch.hw_mmu->pgt, ALIGN_DOWN(ipa, PAGE_SIZE),
> +			 PAGE_SIZE, &walker);
> +
> +	/* Must be a PAGE_SIZE mapping with our annotation */
> +	return (BIT(ARM64_HW_PGTABLE_LEVEL_SHIFT(data.level)) == PAGE_SIZE &&
> +		data.pteval == MMIO_NOTE);

Nit: you could do this check in the walker directly and check the return
value of kvm_pgtable_walk() instead. That would allow to get rid of
struct s2_walk_data.

Also, though the compiler might be able to optimize, maybe simplify the
level check to level == (KVM_PGTABLE_MAX_LEVELS - 1)?

Thanks,
Quentin

> +}
