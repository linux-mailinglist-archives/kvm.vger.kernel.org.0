Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 603207B99A8
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 03:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244337AbjJEBbH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Oct 2023 21:31:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244316AbjJEBbF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Oct 2023 21:31:05 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2116B9E
        for <kvm@vger.kernel.org>; Wed,  4 Oct 2023 18:31:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d81ff714678so572178276.2
        for <kvm@vger.kernel.org>; Wed, 04 Oct 2023 18:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1696469461; x=1697074261; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n4rUp4ycIq42eNA+TiEjWeknoevELPustb2kr/eeWpE=;
        b=qFYX/33gZkpFdN2cZeP4/FpuO+hIRx7KRmgp5rQnZYJx1yzB8prMntf6xqAbofALTU
         IHLP7PMAStE1XI0/x+aQsoCbI6yATyIYp0Bwx9BIAo6lJq60x4OIalJNiGn04OQJ+yuy
         ZQn21qCavd/cPk9kB/bGle8WURpjrrWcmKQEL1rBVScapMAAF63JMzMDSuwULWiXdmeh
         WNWtUYki7v6UyqfVS9JeNVaGgULfz9LBMj/ARTN7UxASqTQjJBQztbNcCqldLKE9/D6d
         L44KPEXF3UTIG0QGSHHgdSc2X+vAJRM65GEBMtj6XyvH1Nqqw1U0dLZiPexyr+XTigUS
         4thw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696469461; x=1697074261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n4rUp4ycIq42eNA+TiEjWeknoevELPustb2kr/eeWpE=;
        b=U1xCgerVY4qIY54S4Gr+YBvRlmM1B8y45mGqduUhDWndx1TvWL5twMkIOX6WEQO82B
         etXhNFzkmMLqYacSkeuCY5e6DhIgXhqPa/5ejYqKCRhbSCbdyj9vW0Blt60OJtErG7Ax
         U6SLpF2WRYKdib9xthseYKy2TzpydoyQzH8NWL/QJ3kzEr3wOUd6abXxfx0PAmT3pWsu
         Nepj4gz7/KyWSMSd4gppD1pWl+MHqk/NvYR/rjZiKGzuPYZ5hoQSBEkYk1HbpXvIhnr8
         o5CFAq6SaGq5z5GWzJz2Vri2qPKFNbHnaMRD/17q5ExdrqZvB2aoUIormIZdNHjYR3Ig
         10NA==
X-Gm-Message-State: AOJu0YyVTPWScJLE1vR7iC+KLjD9a77qtAlpq0wZoiaFPgICY6GdeStB
        dR79mX6eV7rJwYvFfdqy2a0YuBre7Yk=
X-Google-Smtp-Source: AGHT+IGEGdjaYi0uhAKU0dgOZv9UropbH1j3a8mHl2nLotZXWoY+6JAiTu0z3FrhAbKy13iKfeyOLNoughI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:d389:0:b0:d80:19e5:76c8 with SMTP id
 e131-20020a25d389000000b00d8019e576c8mr52218ybf.12.1696469461343; Wed, 04 Oct
 2023 18:31:01 -0700 (PDT)
Date:   Wed,  4 Oct 2023 18:29:27 -0700
In-Reply-To: <20230714064656.20147-1-yan.y.zhao@intel.com>
Mime-Version: 1.0
References: <20230714064656.20147-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.42.0.582.g8ccd20d70d-goog
Message-ID: <169644820856.2740703.143177409737251106.b4-ty@google.com>
Subject: Re: [PATCH v4 00/12] KVM: x86/mmu: refine memtype related mmu zap
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yan Zhao <yan.y.zhao@intel.com>
Cc:     pbonzini@redhat.com, chao.gao@intel.com, kai.huang@intel.com,
        robert.hoo.linux@gmail.com, yuan.yao@linux.intel.com
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Jul 2023 14:46:56 +0800, Yan Zhao wrote:
> This series refines mmu zap caused by EPT memory type update when guest
> MTRRs are honored.
> 
> Patches 1-5 revolve around utilizing helper functions to check if
> KVM TDP honors guest MTRRs, TDP zaps and page fault max_level reduction
> are now only targeted to TDPs that honor guest MTRRs.
> 
> [...]

Applied 1-5 and 7 to kvm-x86 mmu.  I squashed 1 and 2 as introducing helpers to
consolidate existing code without converting the existing code is wierd and
makes it unnecessarily impossible to properly test the helpers when they're
added.

I skipped 6, "move TDP zaps from guest MTRRs update to CR0.CD toggling", for
now as your performance numbers showed that it slowed down the guest even
though the number of zaps went down.  I'm definitely not against the patch, I
just don't want to risk regressing guest performance, i.e. I don't wantt to
take it without the rest of the series that takes advantage of the change.

I massaged a few shortlogs and changelogs, but didn't touch any code.  Holler
if anything looks funky.

Thanks much!

[1/5] KVM: x86/mmu: Add helpers to return if KVM honors guest MTRRs
      https://github.com/kvm-x86/linux/commit/6590a37e7ec6
[2/5] KVM: x86/mmu: Zap SPTEs when CR0.CD is toggled iff guest MTRRs are honored
      https://github.com/kvm-x86/linux/commit/c0ad4a14c5af
[3/5] KVM: x86/mmu: Zap SPTEs on MTRR update iff guest MTRRs are honored
      https://github.com/kvm-x86/linux/commit/a1596812cce1
[4/5] KVM: x86/mmu: Xap KVM TDP when noncoherent DMA assignment starts/stops
      https://github.com/kvm-x86/linux/commit/3c4955c04b95
[5/5] KVM: VMX: drop IPAT in memtype when CD=1 for KVM_X86_QUIRK_CD_NW_CLEARED
      https://github.com/kvm-x86/linux/commit/f7b4bcd501ef

--
https://github.com/kvm-x86/linux/tree/next
