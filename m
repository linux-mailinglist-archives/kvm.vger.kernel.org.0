Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5DC55FEF82
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 16:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiJNOBD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 10:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230289AbiJNOAj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 10:00:39 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDEFF7CE15
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 07:00:17 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id m6so2473762qkm.4
        for <kvm@vger.kernel.org>; Fri, 14 Oct 2022 07:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qcbPZWPJBvSlgI0JaT98JkQa2BdMkjvTQHHNjJDLWR8=;
        b=cWHaCe+7NiLWV3T+fjLF8EZtlhexGbCg+WEq/dCVkwZlV9OSmlvmQvAf8tHOWxlB15
         R1drmhQ65EsQ2EK/mhECj9QEh2CQLLNUzqJ9oqoPSSrkne89KFSq4YWdvfq9IP7Uota4
         7XZtiYtVxdCKWb4baqEwWC8JB6Fdyr6kl2BDZy+wPH+ZpnDQcjanaP3WyBwV3Z1PZzGD
         CZWPDEfUXKdIW6mrakAhQPVrXN8JnsQ5WVKDAxqsL5jcUEWUMlF+wYwCnWrfob8HgcIT
         Gi3IrihaKlsefDNPRlWX3Hqdb8YfdREQACdRk26hiLm8LTNeDPPdkOwUpLkPKgwwv3Yz
         5VcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qcbPZWPJBvSlgI0JaT98JkQa2BdMkjvTQHHNjJDLWR8=;
        b=ATFkpD1me/aFgKZ0+1qNBme+igfCHzusZbvgezfaEIUOu2xVV6g2XEVHH/TYAOLQ3D
         FvRDqrbNZrIj5WJes/MSUA6/8xUsHLHcXsYVdTb0YCzYa/qiOLsGz5deWkT6PhMdNi3a
         K/TRIUHwR9x7QcvuwKDgvbQDAM6AkLT8K7cYQDSZNM6gb9PGlZdtfuvMrnZlWWcKWbpi
         cXUwK1+ElgF/qxyQAOO6zGJDwFqTCb6RdwwzF/bnD+a0zERyFDsAkrFOu9g77tol5r4y
         hRZaj/0Pd2WSoVYzGV5YhK+OwGdWlUbBGpPTggVmLy0PddWgdm3CHOw4pH9C/VbCO5Td
         PVeA==
X-Gm-Message-State: ACrzQf2HNDFxAofzpH6+S3+WIf9G9a6oCvFfBbz+5O3eeCd5cG2cgZHu
        cJ+/Pt01wpi+H9lOFK2/6jQlWA==
X-Google-Smtp-Source: AMsMyM6IwCN+c1z62UhOHVbSClec5ccka72g2QriRCYRsTQFGoKqENCt7u1RwIvsCpE32fxIp3ANJA==
X-Received: by 2002:a05:620a:4107:b0:6ee:ce95:1d15 with SMTP id j7-20020a05620a410700b006eece951d15mr1769931qko.266.1665755892583;
        Fri, 14 Oct 2022 06:58:12 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-122-23.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.122.23])
        by smtp.gmail.com with ESMTPSA id k15-20020a05620a414f00b006ce40fbb8f6sm2605722qko.21.2022.10.14.06.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 06:58:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
        (envelope-from <jgg@ziepe.ca>)
        id 1ojLCU-0033hQ-T0;
        Fri, 14 Oct 2022 10:58:10 -0300
Date:   Fri, 14 Oct 2022 10:58:10 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     "Radovanovic, Aleksandar" <aleksandar.radovanovic@amd.com>
Cc:     "Gupta, Nipun" <Nipun.Gupta@amd.com>,
        Marc Zyngier <maz@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "eric.auger@redhat.com" <eric.auger@redhat.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Gupta, Puneet (DCG-ENG)" <puneet.gupta@amd.com>,
        "song.bao.hua@hisilicon.com" <song.bao.hua@hisilicon.com>,
        "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jeffrey.l.hugo@gmail.com" <jeffrey.l.hugo@gmail.com>,
        "saravanak@google.com" <saravanak@google.com>,
        "Michael.Srba@seznam.cz" <Michael.Srba@seznam.cz>,
        "mani@kernel.org" <mani@kernel.org>,
        "yishaih@nvidia.com" <yishaih@nvidia.com>,
        "will@kernel.org" <will@kernel.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "ndesaulniers@google.com" <ndesaulniers@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "okaya@kernel.org" <okaya@kernel.org>,
        "Anand, Harpreet" <harpreet.anand@amd.com>,
        "Agarwal, Nikhil" <nikhil.agarwal@amd.com>,
        "Simek, Michal" <michal.simek@amd.com>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: Re: [RFC PATCH v3 4/7] bus/cdx: add cdx-MSI domain with gic-its
 domain as parent
Message-ID: <Y0lq8vB2PT0zKUAQ@ziepe.ca>
References: <20220906134801.4079497-5-nipun.gupta@amd.com>
 <87h71juxuk.wl-maz@kernel.org>
 <DM6PR12MB30820EE430405FF50C7F856BE8229@DM6PR12MB3082.namprd12.prod.outlook.com>
 <MN2PR12MB43586084670E14691920952889229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0a65a9leWXpKfTo@ziepe.ca>
 <MN2PR12MB4358A871519748CD7A6DB7A089229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0bRZTP9Kc6mdCiu@ziepe.ca>
 <MN2PR12MB4358277977C1B7E0BC214AC789229@MN2PR12MB4358.namprd12.prod.outlook.com>
 <Y0gH8R8tEqn6sqZ5@ziepe.ca>
 <MN2PR12MB4358CF6B6D2576B35E39328A89249@MN2PR12MB4358.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR12MB4358CF6B6D2576B35E39328A89249@MN2PR12MB4358.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 14, 2022 at 11:18:36AM +0000, Radovanovic, Aleksandar wrote:

> And that still does not imply lack of ordering or sharing of MSI
> target addresses between devices.

Either the end point generates the MSI, and maybe the bridge mangles
it, or it raises a lot of suspicion that this is not right. If the end
point generates the MSI then it raises the question why do we need to
tolerate these limits?

> This is a highly programmable IP block, at the core of which is an
> interconnect interfacing to programmable logic (PL), a number of
> PCIe controllers (either endpoint or root-port), DMA engines,
> offload engines, the embedded processor subsystem (PSX), etc. DMA
> and interrupts can be routed across it in almost any (meaningful)
> direction. The datapath 'endpoints' request DMA and interrupts, but
> don't concern themselves with the mechanics of delivering that in
> the target domain. It is the responsibility of the egress bridges to
> the target domains to convert the interconnect interrupt
> transactions to whatever the interrupt delivery mechanism for that
> domain is. E.g. for PCIe controllers in endpoint mode, that would be
> through PCIe MSI-X tables internal to the controller (and managed by
> the PCIe host), for PSX that would be the PSX bridge (partially
> managed by the PSX OS, mediated through firmware, i.e. through CDX
> bus driver) and so on. It is the responsibility of the interconnect
> to maintain transaction ordering (including DMA vs. interrupts). It
> is the responsibility of the firmware to manage the bridges
> according to the implemented use-case, so everything works as
> expected.

Again, this all just seems wrongly designed. MSI should not be part
of an interconnect bridge. We did that already 20 years ago, it was
called IOAPICs on x86 and I think everyone is happy to see it gone.

If you want to build IOAPICs again, I guess you can, but that is a
slightly different SW setup than the MSI you are trying to use here,
and even that didn't have the same limitations you are proposing.

> So, yes, the hardware that translates interrupt transactions to GIC
> AXI writes is shared between endpoints, but what I said above still
> applies. And that doesn't necessarily make it weird/wrong, it's just
> more complex than you might think.

If it doesn't fit the architecture, then I think it must be considered
wrong. Mis-using platform architected components like MSI in HW is
problematic.

You should design the HW properly so you don't have these
problems. Involving FW in the MSI setup is also a bad idea, POWER did
this and it made a big mess of their arch code :(

Jason
