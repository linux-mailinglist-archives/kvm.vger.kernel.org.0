Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABCC1734E68
	for <lists+kvm@lfdr.de>; Mon, 19 Jun 2023 10:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230160AbjFSIrM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Jun 2023 04:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjFSIq1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Jun 2023 04:46:27 -0400
Received: from out-47.mta0.migadu.com (out-47.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183DC171F
        for <kvm@vger.kernel.org>; Mon, 19 Jun 2023 01:45:01 -0700 (PDT)
Date:   Mon, 19 Jun 2023 10:44:55 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1687164297;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Sq37y9S8SOH6zcDLYH4r3pNx1GxNy9n4Ig1VcBFiFVI=;
        b=ZE14BNqlo/u0wkBYO9ZAu7fn8bjhrMefEVkrdtxgWSAdoNuTHvebaV4fbYnHwalqr04aRS
        lBBTH2ngKqDXkHyBK16fvfpiGKrIdw19KilgQqfmRCFHFlLjGfeSyP1vrwFw58kN2F6hRW
        RIFTDn2kCNWNKHNmsIC5Ymob8PCLDRg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Gavin Shan <gshan@redhat.com>
Cc:     Nico Boehr <nrb@linux.ibm.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org, lvivier@redhat.com, thuth@redhat.com,
        frankja@linux.ibm.com, imbrenda@linux.ibm.com, david@redhat.com,
        pbonzini@redhat.com, shan.gavin@gmail.com
Subject: Re: [kvm-unit-tests PATCH v3] runtime: Allow to specify properties
 for accelerator
Message-ID: <20230619-5565bc462dab3f2d6f7f26c3@orel>
References: <20230615062148.19883-1-gshan@redhat.com>
 <168683636810.207611.6242722390379085462@t14-nrb>
 <2a1b0e2b-a412-143a-9a57-5f2c12e8944c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a1b0e2b-a412-143a-9a57-5f2c12e8944c@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023 at 10:41:29AM +1000, Gavin Shan wrote:
> Hi Nico,
> 
> On 6/15/23 23:39, Nico Boehr wrote:
> > Quoting Gavin Shan (2023-06-15 08:21:48)
> > > There are extra properties for accelerators to enable the specific
> > > features. For example, the dirty ring for KVM accelerator can be
> > > enabled by "-accel kvm,dirty-ring-size=65536". Unfortuntely, the
> > > extra properties for the accelerators aren't supported. It makes
> > > it's impossible to test the combination of KVM and dirty ring
> > > as the following error message indicates.
> > > 
> > >    # cd /home/gavin/sandbox/kvm-unit-tests/tests
> > >    # QEMU=/home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
> > >      ACCEL=kvm,dirty-ring-size=65536 ./its-migration
> > >       :
> > >    BUILD_HEAD=2fffb37e
> > >    timeout -k 1s --foreground 90s /home/gavin/sandbox/qemu.main/build/qemu-system-aarch64 \
> > >    -nodefaults -machine virt -accel kvm,dirty-ring-size=65536 -cpu cortex-a57             \
> > >    -device virtio-serial-device -device virtconsole,chardev=ctd -chardev testdev,id=ctd   \
> > >    -device pci-testdev -display none -serial stdio -kernel _NO_FILE_4Uhere_ -smp 160      \
> > >    -machine gic-version=3 -append its-pending-migration # -initrd /tmp/tmp.gfDLa1EtWk
> > >    qemu-system-aarch64: kvm_init_vcpu: kvm_arch_init_vcpu failed (0): Invalid argument
> > > 
> > > Allow to specify extra properties for accelerators. With this, the
> > > "its-migration" can be tested for the combination of KVM and dirty
> > > ring.
> > > 
> > > Signed-off-by: Gavin Shan <gshan@redhat.com>
> > 
> > Maybe get_qemu_accelerator could be renamed now, since it doesn't actually "get"
> > anything, so maybe check_qemu_accelerator?
> > 
> > In any case, I gave it a quick run on s390x with kvm and tcg and nothing seems
> > to break, hence for the changes in s390x:
> > 
> > Tested-by: Nico Boehr <nrb@linux.ibm.com>
> > Acked-by: Nico Boehr <nrb@linux.ibm.com>
> > 
> 
> Thanks for a quick try and comment for this. I guess it's fine to keep the
> function name as get_qemu_accelator() because $ACCEL is split into $ACCEL
> and $ACCEL_PROPS inside it, even it don't print the accelerator name at
> return. However, I'm also fine with check_qemu_accelerator(). Lets see
> what's Drew's comment on this and I can post v4 to have the modified
> function name, or an followup patch to modify the function name.

I suggested naming it set_qemu_accelerator() in the v2 review.

Thanks,
drew
