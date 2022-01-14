Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDE148EEA6
	for <lists+kvm@lfdr.de>; Fri, 14 Jan 2022 17:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243573AbiANQt0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 11:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241976AbiANQtZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 11:49:25 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59B2C06161C
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 08:49:25 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id l6-20020a17090a4d4600b001b44bb75a8bso2373033pjh.3
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 08:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A9GSJbbyUEooumrboslZcyMcawaKEGAeavwi+WIG2HU=;
        b=gvzvuaOhiMwelFKjT2eA3SuvMgjgCVJCB5Fn4zi0b7WuenQMWW1B3q0JFT3Cc/9k4B
         FjfTSy/Rig4rJMnkgbJobqN0LBkuvIPnzr9PP1Vj4i3YfeJ+wowpLkvkbIQt6VEVqbsB
         MeNZ691pqSk+okT9m4klCxY3Rvn33C0GVpIHCqkdnTor5vyGfMCY8yRyHs8E4PBTgn3O
         VJ0dWuSnshJb5Tlth8KiRF2syz2qdjXk1ANDhP+it3Nzk4dNZUwiysocuqoVjF+RG5WD
         4HlkwN2qU9v4t637p2Z/UYCbmbB2Iju7gOCyYY05CPez7qRuGpBiiyHxWHnifS3c7JoS
         GZCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A9GSJbbyUEooumrboslZcyMcawaKEGAeavwi+WIG2HU=;
        b=l82I4OkwabkIxYmlpUTJOoMI+0D8Ps2XpM8Bzlc4UHnqY9HEwetEIfMY8k+SgqriOK
         R0wKMidHBJ3Jg7Y0K8HrYGfT27CwYjwAvss/AvCyjBBfco9r+ozQS3Okbp6DH2cq93j1
         4kDMVNNssVRqdA1sf4leuizaUr/WxJsbNRzS31/Z53IKLP76LnH1xExioKPCPUge3Tx1
         8xuXgcUfGJ8LIlJxxH3Y5ayVEa7K5GeoqtJuXG420PBZisEYICXAkKBxbms++YAdnO1l
         Oo51e0hd/CGoEJgUJAJ80l+TFdTr84Ggp8gN+ZB+roYaqOqld8eJWG+61dmgbXHo9YFC
         omUw==
X-Gm-Message-State: AOAM532H7aucnCOfxwgsv1r6s/KXSixiFCHePuex1FFuxJINmBrgMHB1
        GPo4955nLkvw8zsgd24Q1TU2kw==
X-Google-Smtp-Source: ABdhPJwH1fVcm9KJ73Qv/1wtWK15LbuLjx35G9q+OO+bqipocVWKgp1D7JHRA1ZHzmLIoZCbfH/yRQ==
X-Received: by 2002:a17:903:2284:b0:14a:61b8:618c with SMTP id b4-20020a170903228400b0014a61b8618cmr10521345plh.127.1642178964921;
        Fri, 14 Jan 2022 08:49:24 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id k19sm6152051pff.5.2022.01.14.08.49.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 08:49:24 -0800 (PST)
Date:   Fri, 14 Jan 2022 16:49:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Mark Rutland <mark.rutland@arm.com>
Cc:     linux-kernel@vger.kernel.org, aleksandar.qemu.devel@gmail.com,
        alexandru.elisei@arm.com, anup.patel@wdc.com,
        aou@eecs.berkeley.edu, atish.patra@wdc.com,
        benh@kernel.crashing.org, borntraeger@linux.ibm.com, bp@alien8.de,
        catalin.marinas@arm.com, chenhuacai@kernel.org,
        dave.hansen@linux.intel.com, david@redhat.com,
        frankja@linux.ibm.com, frederic@kernel.org, gor@linux.ibm.com,
        hca@linux.ibm.com, imbrenda@linux.ibm.com, james.morse@arm.com,
        jmattson@google.com, joro@8bytes.org, kvm@vger.kernel.org,
        maz@kernel.org, mingo@redhat.com, mpe@ellerman.id.au,
        nsaenzju@redhat.com, palmer@dabbelt.com, paulmck@kernel.org,
        paulus@samba.org, paul.walmsley@sifive.com, pbonzini@redhat.com,
        suzuki.poulose@arm.com, tglx@linutronix.de,
        tsbogend@alpha.franken.de, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org
Subject: Re: [PATCH 5/5] kvm/x86: rework guest entry logic
Message-ID: <YeGpkQymsl4SbLRy@google.com>
References: <20220111153539.2532246-1-mark.rutland@arm.com>
 <20220111153539.2532246-6-mark.rutland@arm.com>
 <YeCQeHbswboaosoV@google.com>
 <YeFnD8l/OoMtPYvh@FVFF77S0Q05N>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YeFnD8l/OoMtPYvh@FVFF77S0Q05N>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 14, 2022, Mark Rutland wrote:
> I assume that other than the naming of the entry/exit functions you're happy
> with this patch?

Yep!
