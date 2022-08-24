Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF7B5A0323
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 23:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240057AbiHXVIz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 17:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233133AbiHXVIy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 17:08:54 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B25796AB
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 14:08:52 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id w138so15069474pfc.10
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 14:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=/h4kOyHP46X43kQG6NQXXVAKCHL+YZ4y4xLu+bGaWYM=;
        b=cwcBlsPxRdk3XeWRUreTskl53H9+5FSGjnMWdcMjsVYlDnnee+Az4x8J6jXE7du94K
         kKvqTnHTX3i7cXkh8OuXPiNNhjprD1nG4zD2dTu15IYwTISXJU1FXlWYrKI7roqgK05P
         iB+MiKbJoA/0R9lIj/PCJydD4LldWOAgXGlOyTqMWrpRsCJsCOO2D1I3d/QFiwQGlgmH
         W8EwvuFp+ZrqLslH0mO9eP+KbxbANZfwRxe1J4l1/ZrstwvypUc+jYYRGjSqhhTVGJUH
         6SArSVurtFtpyIpztTivIRYWAtfr5U8w9s+6kBT01ar64HoE2oEoWFoqIQuzZJeNbIuX
         LbNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=/h4kOyHP46X43kQG6NQXXVAKCHL+YZ4y4xLu+bGaWYM=;
        b=d0vZW0iXfGjd5G7SB2yCARyUATPR8/tlxaBTJOwULRngWhoV7G3Jzl7q3JySmxt2Gl
         Evzox3Vb6lXuM09m8KfiMRGq5NiAQQFc3XIj76GYF5ALOzL+NuIIsowjz7A38LnVS/Rl
         eVi37xJogqVoSrswVUnsPpUjHV+sNvXB9b3Yb2igIqTTB5ZfSfECGIxqhKL/0G2+exlq
         bbS22ERcX3DrIEQgxOJtOW2/psEilXE/UgVTD1MKbgy7xewhntzgKpj5Pe3mrxznhCx2
         JudZDBFbaWO7Z48aGX6qMLiap+sfiyfeCYoGuGWdegDbj36G8VA6iaP49785QARD4AG/
         uXiw==
X-Gm-Message-State: ACgBeo0A2P7rGDz5Rm7nInrXoKPRalMzjx7vQCmQ/kuGNqRo2I3U3i6G
        5Ybp+v/D2WDAONatwGLTVpIoKg==
X-Google-Smtp-Source: AA6agR4JWyvRqXWOx88AQZo2m3/E2P8Fe1MV7l0ifpCJivKRr7nDN0BCCEr+IF5HcNidBzynrcbGJQ==
X-Received: by 2002:a05:6a00:8cf:b0:522:93a6:46e9 with SMTP id s15-20020a056a0008cf00b0052293a646e9mr978816pfu.62.1661375332173;
        Wed, 24 Aug 2022 14:08:52 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id q15-20020a17090311cf00b0016d1f6d1b99sm13071802plh.49.2022.08.24.14.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 14:08:51 -0700 (PDT)
Date:   Wed, 24 Aug 2022 21:08:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Matlack <dmatlack@google.com>,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Kai Huang <kai.huang@intel.com>,
        Michael Roth <michael.roth@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v2 2/3] KVM: x86/mmu: Fully re-evaluate MMIO caching when
 SPTE masks change
Message-ID: <YwaTX88JZUKPwyqX@google.com>
References: <20220803224957.1285926-1-seanjc@google.com>
 <20220803224957.1285926-3-seanjc@google.com>
 <CALzav=e_H0LU+2-KcG_bPahVhJM8YGnH24J6aJ9HG9Eqj-waew@mail.gmail.com>
 <bab3cc28-4473-d446-bb6d-bca6939adb63@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bab3cc28-4473-d446-bb6d-bca6939adb63@redhat.com>
X-Spam-Status: No, score=-14.5 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,FSL_HELO_FAKE,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 19, 2022, Paolo Bonzini wrote:
> On 8/19/22 18:21, David Matlack wrote:
> > On Wed, Aug 3, 2022 at 3:50 PM Sean Christopherson <seanjc@google.com> wrote:
> > > 
> > > Fully re-evaluate whether or not MMIO caching can be enabled when SPTE
> > > masks change; simply clearing enable_mmio_caching when a configuration
> > > isn't compatible with caching fails to handle the scenario where the
> > > masks are updated, e.g. by VMX for EPT or by SVM to account for the C-bit
> > > location, and toggle compatibility from false=>true.
> > > 
> > > Snapshot the original module param so that re-evaluating MMIO caching
> > > preserves userspace's desire to allow caching.  Use a snapshot approach
> > > so that enable_mmio_caching still reflects KVM's actual behavior.
> > 
> > Is updating module parameters to reflect the actual behavior (vs.
> > userspace desire) something we should do for all module parameters?
> > 
> > I am doing an unrelated refactor to the tdp_mmu module parameter and
> > noticed it is not updated e.g. if userspace loads kvm_intel with
> > ept=N.
> 
> If it is cheap/easy then yeah, updating the parameters is the right thing to
> do.  Generally, however, this is only done for kvm_intel/kvm_amd modules
> that depend on hardware features, because they are more important for
> debugging user issues.  (Or at least they were until vmx features were added
> to /proc/cpuinfo).

IMO, unless it's _really_ hard, KVM should keep the parameters up-to-date with
reality, e.g. so that userspace can assert that a feature is fully enabled, either
for testing purposes (unrestricted guest?) or to prevent running with a "bad" config.

We've had at least one internal OMG-level bug where KVM effectively ran with the
wrong MMU configuration, and IIRC one of the actions taken in response to that was
to assert on KVM's parameters post-load.
