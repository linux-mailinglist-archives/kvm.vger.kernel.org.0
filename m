Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784FA581920
	for <lists+kvm@lfdr.de>; Tue, 26 Jul 2022 19:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239821AbiGZRvj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jul 2022 13:51:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239789AbiGZRuv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Jul 2022 13:50:51 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECA5432BB5
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:50:44 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id f65so13742974pgc.12
        for <kvm@vger.kernel.org>; Tue, 26 Jul 2022 10:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UKelOhAD/MflxLQCD3CV9kXt3f1tm8+576g2JP0lVpo=;
        b=W7QtxS0d7v0FLhrRBjTKZS6Q+aaT1urckWujSbu9ali0265KYUu+LFR3AI5YHakGX+
         mELKyPkdV/nQ7mU/ld7cyu2BEdZqAj3bHyxgBBKNOg+BYYhCoiHBbJvEH8rLjpzKfXJl
         UgdAe6tfldL8UB9r+aAJY8+GTwsaPbUU62dpvsAHnwdblrkSP31Gefmao3dzFMVn1CMB
         AyNq/YwMxbVzUG43/NJGgV0VbvAaCdtiMJ/5Kz/GJIf/O9OJfocMUOTr8i+utPaaowuA
         QgWtzVZcj8fUS4PeUuipl1MK8q8a2ZPQapkLrOD6TZBWoDGKK7nFwKWcJ1nS11GI22Jb
         kI7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UKelOhAD/MflxLQCD3CV9kXt3f1tm8+576g2JP0lVpo=;
        b=iBl2Wx75YfNHQPrEqbDXOmBDIgF6F4AlJlcay3OSR2dBiL3DuOTFVtoLvhi6vKYaLW
         zeB+aoewHNdV98FDM+ehHzZauiErBW/3m3NchBI6cc4phKUBJiMUk4ICd/bKY+nk1+Sv
         tmb5GVuFjHnhOCH31V5pYuL94TtPFJY//pUgxfcGamafOQguEnV2or41hrZvcTblduiO
         OYXFKL2DJDgT2F4WQ4fUmCLlMKdwitRJLxFy9fANlALxTRAG6HFqwechm3Xtq9dAPrZi
         Ge/svaRAWquVR37yFVbloXaj1OSYZFbKporOLBBn7eedMi2HR9l0jxa+pLQm/UdPVHP4
         Zn1A==
X-Gm-Message-State: AJIora8qmvjTqOxUf8j1fn3MWKX3FCoOir7LQ03FbWDLTYzMT+9ofCL+
        ZqE5Qg9RW/ZA3iK8I/8DHglJXQ==
X-Google-Smtp-Source: AGRyM1tJvdhzrKNTIthwDvTfOxqlbckVevLtZ4SxGr4UMG2i25ORucstPh9+wtI0sYmeyzFxmNqc9w==
X-Received: by 2002:a63:2c89:0:b0:411:66bf:9efc with SMTP id s131-20020a632c89000000b0041166bf9efcmr15386950pgs.589.1658857844100;
        Tue, 26 Jul 2022 10:50:44 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id s22-20020a17090b071600b001ecbd9aa1a7sm11112804pjz.1.2022.07.26.10.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jul 2022 10:50:43 -0700 (PDT)
Date:   Tue, 26 Jul 2022 17:50:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Zenghui Yu <yuzenghui@huawei.com>, Sasha Levin <sashal@kernel.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Maxim Levitsky <mlevitsk@redhat.com>, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH MANUALSEL 5.10 1/2] KVM: x86: lapic: don't touch
 irr_pending in kvm_apic_update_apicv when inhibiting it
Message-ID: <YuApb56AjxaeOirP@google.com>
References: <20220222140532.211620-1-sashal@kernel.org>
 <e9e3f438-8699-abba-a1f8-d4d8bfbd63ed@redhat.com>
 <6d900dc3-44c0-5a0d-a545-1a51936e6a80@huawei.com>
 <Yt8sAWd6qvEtZVji@google.com>
 <3f2f83a3-e240-a509-38ca-1b88bdc179d4@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f2f83a3-e240-a509-38ca-1b88bdc179d4@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 26, 2022, Paolo Bonzini wrote:
> On 7/26/22 01:49, Sean Christopherson wrote:
> > On Mon, Jul 25, 2022, Zenghui Yu wrote:
> > > Hi,
> > > 
> > > On 2022/3/2 1:10, Paolo Bonzini wrote:
> > > > On 2/22/22 15:05, Sasha Levin wrote:
> > > > > From: Maxim Levitsky <mlevitsk@redhat.com>
> > > > > 
> > > > > [ Upstream commit 755c2bf878607dbddb1423df9abf16b82205896f ]
> > > > 
> > > > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> > > 
> > > What prevented it to be accepted into 5.10-stable? It can still be
> > > applied cleanly on top of linux-5.10.y.
> > 
> > KVM opts out of the AUTOSEL logic and instead uses MANUALSEL.  The basic idea is
> > the same, use scripts/magic to determine what commits that _aren't_ tagged with an
> > explicit "Cc: stable@vger.kernel.org" should be backported to stable trees, the
> > difference being that MANUALSEL requires an explicit Acked-by from the maintainer.
> 
> But as far as I understand it was not applied, and neither was "KVM: x86:
> nSVM: deal with L1 hypervisor that intercepts interrupts but lets L2 control
> them".

Ah, I misunderstood the question.  I'll get out of the way.
