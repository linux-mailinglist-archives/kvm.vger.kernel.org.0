Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 749FF5FDAEB
	for <lists+kvm@lfdr.de>; Thu, 13 Oct 2022 15:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbiJMNdr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Oct 2022 09:33:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiJMNdp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Oct 2022 09:33:45 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F626CD2C
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 06:33:44 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id y10so1224210wma.0
        for <kvm@vger.kernel.org>; Thu, 13 Oct 2022 06:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wtCloI9hskeDNVZ254m/WnfVkbDM6sWRXNrTkKvw5FY=;
        b=YW8z6aczP59ni0skunR8oi0MaOYp45DzXHwhcdK7CWpUnP5B39YJhV5ewCDGDKUgfb
         XODKvI1+dXZXPs/gz2ycYE0tw/6n+1eOUS4Vz1+uKTt87A312Z3T0sxaIQCm6Dc5+GVx
         3DpQL6CfPKCU/LA0HFGxJ2Se2t33vLI8UrQNVl5MrDvlvSe3UYx4CRMrDgZ2I2/NjkoS
         82b54oP5rxZdq+DNZWVJ/iH3KL9O9sEqFbtskumqU4lFdhmPqp9WdIPau4TvKcT2jL1A
         ZGFNJdKvht+9AQVirDse/nkU60mohW71olHTsNkVHZFgUUITm2dtLCwJLVQN6jN6Hv6l
         10RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wtCloI9hskeDNVZ254m/WnfVkbDM6sWRXNrTkKvw5FY=;
        b=GIKOcqAaX76S1ThgPiLTu2RnzkXiKZ1+ZmyfnRx5GbhUcgXQgj4ltndRGg1RyWa2zC
         dWoiC7Au/ftj7FKans4/KNJuR1v0nxY7k6sOBsrrX7uslxGV+ru2CNsa8iaqa4ijRlCv
         vQiEhg0+NhTOs07VG1bX/Qs6YtWep8C0hvejREDBJAgO1bTJU3d7jhjmJPEqiQE3yxM5
         h1TtG74kpPAiJKTHlf0f5XCBgEJb/vdjiv2W3/mBXPS9wE18UEhq0CNp4O3cSvVy0/bi
         dxgOOonOzHUVQHFDx9pC1TPm1ZIR72a7gsgjho12Gl6bBum/EIE3hD5tCwal7pdhtRqz
         4UYA==
X-Gm-Message-State: ACrzQf332vn4g/LkrscDp8NBKt6iA1h9EZjEHHJYrRPQNVcGZmejWB5F
        01XTxzeV/ZglI6e9xJ2/h0anfg==
X-Google-Smtp-Source: AMsMyM5Xvso38gZmW1inlKkLOIsDEX7FDM5OiRgLE55NcJDVGJPiW+JGoOffZ4yRYyETMAV8Z8Ms2g==
X-Received: by 2002:a7b:c341:0:b0:3c4:552d:2ea7 with SMTP id l1-20020a7bc341000000b003c4552d2ea7mr6699736wmj.82.1665668023180;
        Thu, 13 Oct 2022 06:33:43 -0700 (PDT)
Received: from google.com (65.0.187.35.bc.googleusercontent.com. [35.187.0.65])
        by smtp.gmail.com with ESMTPSA id r205-20020a1c44d6000000b003c3a1d8c8e6sm4582858wma.19.2022.10.13.06.33.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Oct 2022 06:33:42 -0700 (PDT)
Date:   Thu, 13 Oct 2022 14:33:38 +0100
From:   Vincent Donnefort <vdonnefort@google.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: pkvm: Fixup boot mode to reflect that the
 kernel resumes from EL1
Message-ID: <Y0gTshQFSTwh+Eqf@google.com>
References: <20221011165400.1241729-1-maz@kernel.org>
 <Y0W6hxc68wi4FO/o@google.com>
 <87pmeygjrl.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pmeygjrl.wl-maz@kernel.org>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 11, 2022 at 09:58:22PM +0100, Marc Zyngier wrote:
> On Tue, 11 Oct 2022 19:48:39 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> > 
> > On Tue, Oct 11, 2022 at 05:54:00PM +0100, Marc Zyngier wrote:
> > > The kernel has an awfully complicated boot sequence in order to cope
> > > with the various EL2 configurations, including those that "enhanced"
> > > the architecture. We go from EL2 to EL1, then back to EL2, staying
> > > at EL2 if VHE capable and otherwise go back to EL1.
> > > 
> > > Here's a paracetamol tablet for you.
> > 
> > Heh, still have a bit of a headache from this :)
> > 
> > I'm having a hard time following where we skip the EL2 promotion based
> > on __boot_cpu_mode.
> > 
> > On the cpu_resume() path it looks like we take the return of
> > init_kernel_el() and pass that along to finalise_el2(). As we are in EL1
> > at this point, it seems like we'd go init_kernel_el() -> init_el1().
> > 
> > What am I missing?
> 
> That I'm an idiot.
> 
> This is only necessary on pre-6.0, before 005e12676af0 ("arm64: head:
> record CPU boot mode after enabling the MMU"), as this code-path
> *used* to reload the boot mode from memory. Now, this is directly
> passed as a parameter, making this patch useless.

On a 5.10 though, the suprious HVCs are gone and I have not observed any
regression.

Thanks!

For a stable fix:

Tested-by: Vincent Donnefort <vdonnefort@google.com>

> 
> The joys of looking at too many code bases at the same time... I'll
> see how we can add it to 5.19.
> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
