Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F01C76DBFC
	for <lists+kvm@lfdr.de>; Thu,  3 Aug 2023 02:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233384AbjHCAGt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Aug 2023 20:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbjHCAGd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Aug 2023 20:06:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B9B1421E
        for <kvm@vger.kernel.org>; Wed,  2 Aug 2023 17:06:04 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-c6dd0e46a52so370149276.2
        for <kvm@vger.kernel.org>; Wed, 02 Aug 2023 17:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691021154; x=1691625954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=24xpWy5jqWvnaUWcLSAqh6x2b0mz42plt2nZzdQyqhk=;
        b=J0wDGRo3GVgo0cQOQvYi6z+1Z9xEECkzTI0o3sOeSAfztMRUBv0/edPKcXdVgWCJoN
         bUCDfFYNfaRLtCy+y43YvhRDbIoeD4FrXPn0QCerDk0zwiIa77efRqrzAOpKZ1lpHnTo
         XT+it1KSz15jDTo69J0uHerP9G7HuXFQZGLDa/fpIwCKafjhUpaShneLrzRcRyUD/85l
         71nmJqWRNT9PhBXMISpzibjMCVWN22es9FNI8OCdF0YX/8G2Loi0sgWJTm9G6vo8SutM
         bFe76GDNCL9EJk2+gVB4Nz4hpnV8MKjJh692U6w6wVr9AgD5Fr6/rGTaOis2kViFzGBr
         8HxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691021154; x=1691625954;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=24xpWy5jqWvnaUWcLSAqh6x2b0mz42plt2nZzdQyqhk=;
        b=PmMCqdksTUEgd00wz+Ie2MjlwaEPiV/X93Zaj1fsgmUR7g2G/AEVvfTFUKpT74YJRW
         Dua6lUE7zoxuha/D3siT7RURK7sEdIRaxw2DSfktqLb4nujdvT/wA+6GJA73+hVwKzQf
         B+c6QIA7CR45BIShlVaMJ3Bx5ZQ4hROHH9WVS4NKlpHP77pCPa1o4ovEJYWj74wJZDwn
         UYeLNcaCIx4Qh2cj/1cmvHa3igSDNsuKuHLruZRzzo1IMaEutwfb7SEb5jJdEZDz4Wv9
         5BTyA8gfmIDg2vVsD8xb7/i8rLn9Oa8rs17zEITbDL/yf5OCvqmJ3pdOAA4QiRR8Rx15
         3clw==
X-Gm-Message-State: ABy/qLaGgZ/VrZX/6zTovOn7WOyZhIxHJAtKunZuGapaoKBPAu4i4HZt
        jqRkxhcYnxsOBffl6gtRZ64rIpzHlu4=
X-Google-Smtp-Source: APBJJlEmoDryPaAQoynG+0QllaP7SCbPdVOfYdjwezb/OIO5nbMPPapZeNIsHeV5kRXSKPVLYXRDkBg6IHU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1582:b0:d0a:353b:b93b with SMTP id
 k2-20020a056902158200b00d0a353bb93bmr144582ybu.3.1691021154336; Wed, 02 Aug
 2023 17:05:54 -0700 (PDT)
Date:   Wed,  2 Aug 2023 17:05:51 -0700
In-Reply-To: <20230721233858.2343941-1-seanjc@google.com>
Mime-Version: 1.0
References: <20230721233858.2343941-1-seanjc@google.com>
X-Mailer: git-send-email 2.41.0.585.gd2178a4bd4-goog
Message-ID: <169101967698.1829360.6805677761713115883.b4-ty@google.com>
Subject: Re: [PATCH] KVM: VMX: Drop manual TLB flush when migrating vmcs.APIC_ACCESS_ADDR
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Jul 2023 16:38:58 -0700, Sean Christopherson wrote:
> Remove the superfluous flush of the current TLB in VMX's handling of
> migration of the APIC-access page, as a full TLB flush on all vCPUs will
> have already been performed in response to kvm_unmap_gfn_range() *if*
> there were SPTEs pointing at the APIC-access page.  And if there were no
> valid SPTEs, then there can't possibly be TLB entries to flush.
> 
> The extra flush was added by commit fb6c81984313 ("kvm: vmx: Flush TLB
> when the APIC-access address changes"), with the justification of "because
> the SDM says so".  The SDM said, and still says:
> 
> [...]

Applied to kvm-x86 vmx, thanks!

[1/1] KVM: VMX: Drop manual TLB flush when migrating vmcs.APIC_ACCESS_ADDR
      https://github.com/kvm-x86/linux/commit/775bc098657b

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
