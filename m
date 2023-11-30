Return-Path: <kvm+bounces-2988-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CF567FF8CC
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 18:49:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8E6681C21215
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 17:49:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92795584DD;
	Thu, 30 Nov 2023 17:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ICJLpAgw"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ABE0F4
	for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:49:45 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-db548aff7baso316320276.2
        for <kvm@vger.kernel.org>; Thu, 30 Nov 2023 09:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1701366584; x=1701971384; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=poBE260KekrwVAOgg+M3fF5Kt/ICZ7GAjNWMaWtdSzg=;
        b=ICJLpAgwZbOfuOu7k3JAI8dnsLJszQlCa7NVU62wiaNNst73XZK+ES47fhiEdEnOvr
         +ooCzCai9wy//ibux1cb7ujsI8CBtyd6yNgvkU7/j5GR/ayIOoctD0ru18+Kn9qD9m+Y
         DfTZk91fk6FEGAhmHKo0z6QDnnXKcIkJDo6OMSUfn3yvwk5IJvySTa+WaqWBCP2Ws68M
         dLQ3scKQZPQf1Gzhjc0NWW9X23qBHYlOm3iikWABViIXwRyb++EDa8kSZbv58tmmpmx3
         HungqifzqNzLLedVOx3m6Iou29MVdurIlDvusdm4c7bNvLj1r7cl5fluDDOlpph5DVHi
         VA1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701366584; x=1701971384;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=poBE260KekrwVAOgg+M3fF5Kt/ICZ7GAjNWMaWtdSzg=;
        b=TcmXqAys0IaHEXgdhMyfnaZ5+9rgdz+uoItWtZomcDudeCRL+OWOUgfZcnU6AC8L+H
         W5ZrS5imFBcTfrfa1pFMgHLfqoaj90obir9+8SSdq+8LWV7F799rTBCLP6f6iV4fP6rv
         4TtLxJOjikihcPoSRDiRaqgPzfvXz3r2NdLd5VFQIK2Szb5d8jDBOXNff83cMjWev1ir
         0kaqY2hKKyLZPyhDr8/HvDbXVyxjMnPPyzqVasiF1hJ3ut1NKkjNHGfHp4FH2CMKGNwW
         Z1lIfFqPfG52lxhKrbBFOerOtC9tXAfrn3cfDV2ok77wXB8m2josduFmg6xAuED2esKx
         DM6Q==
X-Gm-Message-State: AOJu0YzfvsW/uFrGtMplnSLrmv33hyQTOJbA3UDxWpL75qZkOmsZztdi
	bayYxUc8zabGQv4Fj44Lhd8cjB0kTBo=
X-Google-Smtp-Source: AGHT+IFKIQiSFMhY9qIDegdCeGs56VhwQM1SLPMyPsnHTxpb4uIQIzrRqUJpJKjBsiy/h0VKitgvRRcgueU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:3383:0:b0:da0:c6d7:8231 with SMTP id
 z125-20020a253383000000b00da0c6d78231mr749060ybz.0.1701366584635; Thu, 30 Nov
 2023 09:49:44 -0800 (PST)
Date: Thu, 30 Nov 2023 09:49:43 -0800
In-Reply-To: <87v89jmc3q.fsf@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <202311302231.sinLrAig-lkp@intel.com> <87v89jmc3q.fsf@redhat.com>
Message-ID: <ZWjLN3As3vz5lXcK@google.com>
Subject: Re: arch/x86/kvm/vmx/hyperv.h:79:30: sparse: sparse: cast truncates
 bits from constant value (1b009b becomes 9b)
From: Sean Christopherson <seanjc@google.com>
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: kernel test robot <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, 
	linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Thu, Nov 30, 2023, Vitaly Kuznetsov wrote:
> kernel test robot <lkp@intel.com> writes:
> 
> > tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> > head:   3b47bc037bd44f142ac09848e8d3ecccc726be99
> > commit: a789aeba419647c44d7e7320de20fea037c211d0 KVM: VMX: Rename "vmx/evmcs.{ch}" to "vmx/hyperv.{ch}"
> > date:   1 year ago
> > config: x86_64-randconfig-123-20231130 (https://download.01.org/0day-ci/archive/20231130/202311302231.sinLrAig-lkp@intel.com/config)
> > compiler: clang version 16.0.4 (https://github.com/llvm/llvm-project.git ae42196bc493ffe877a7e3dff8be32035dea4d07)
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231130/202311302231.sinLrAig-lkp@intel.com/reproduce)
> >
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202311302231.sinLrAig-lkp@intel.com/
> >
> > sparse warnings: (new ones prefixed by >>)
> >    arch/x86/kvm/vmx/hyperv.h:79:30: sparse: sparse: cast truncates bits from constant value (a000a becomes a)
> 
> This is what ROL16() macro does but the thing is: we actually want to
> truncate bits by doing an explicit (u16) cast. We can probably replace
> this with '& 0xffff':
> 
> #define ROL16(val, n) ((((u16)(val) << (n)) | ((u16)(val) >> (16 - (n)))) & 0xffff)
> 
> but honestly I don't see much point...

Yeah, just ignore 'em, we get the exact same sparse complaints in vmcs12.c and
have had great success ignoring those too :-)

