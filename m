Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C24841CDDE
	for <lists+kvm@lfdr.de>; Wed, 29 Sep 2021 23:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346861AbhI2VPp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Sep 2021 17:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346858AbhI2VPj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Sep 2021 17:15:39 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FBEC06161C
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 14:13:57 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id e7so4037264pgk.2
        for <kvm@vger.kernel.org>; Wed, 29 Sep 2021 14:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KbRE22C2Urnjzjb1q6qIJXeNdCz8YldSbiMhpvJgqP8=;
        b=q7jgC1tIuSBiyGYB2lV4vStjQp4S4+jiLp6o3ynxq1hGdINLeLYSkDQGbHxELMztO2
         Fg35Xt41dFcxowBihgXc2GdNfQXvtZHbROAosciRwVcmguh9JHEkcGJs1Ftyxk+L5pc0
         BZup7dp7yyNx3y3u/Xz6LS67wKtizZ37jbUfLgVkIt/bgt4c09PMpyh6MeRnhmEtfhUv
         Bj1mnI8BN/giqq5D+pusxUvv2a4o8QemjH8W3UuPl75PL5YRukLhrUmBso8SE+YDACzz
         w8Q73eINzgzV+xQ00aAm/r7D7xlNS7U5eP+A2NVJ4TM35DbmMx4lasrLbRCe6ihEqiSV
         bhHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KbRE22C2Urnjzjb1q6qIJXeNdCz8YldSbiMhpvJgqP8=;
        b=1F/By0qqumbo6nhQbip1OpX6jfmOOUJhdEHYUB/BEP/ZnME/enraqgr2IEgi7FPGS0
         6Bt2IHSCTdvSxNho/hw/xRdHZVCOIqkP85QErj4WNT7R8St7vydC0X6uhbRsbto6LlLr
         yAty7+QN8x3b68jgkXRVTzFyVAh8jXgouvQtjpa3d8CqYhOa2ttvsH6240yL9UGNNoIp
         QiRdMWkeLWCLhwDEcthXVtQ1xVNdC+pVwhXdapbqFkIum6SBszMSvWMD0T6LAB1aUbd0
         8g8SaKvtmoyA9gRNSG3Nw7rKNMOjeUhY4wRySLkZB8rZfVo+k/GWTEpyLqKxRkbs8BtF
         8FlQ==
X-Gm-Message-State: AOAM530MM733qNBazT15H2yU4I4aiOLx9jlMLNhJoTmDhC7o61W8O1f+
        tuyOHB92f30LAD0TbtdPWdnnPw==
X-Google-Smtp-Source: ABdhPJwitv8ODNlr3mizyaKdJ+sJBzbYGMNvbTgF4VwP+2jLgpUs2e2jqRx7RkVR7e5jOqxcszmjmA==
X-Received: by 2002:a63:f346:: with SMTP id t6mr1708420pgj.345.1632950036758;
        Wed, 29 Sep 2021 14:13:56 -0700 (PDT)
Received: from google.com (150.12.83.34.bc.googleusercontent.com. [34.83.12.150])
        by smtp.gmail.com with ESMTPSA id c18sm511205pge.69.2021.09.29.14.13.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Sep 2021 14:13:56 -0700 (PDT)
Date:   Wed, 29 Sep 2021 14:13:48 -0700
From:   Ricardo Koller <ricarkol@google.com>
To:     Eric Auger <eric.auger@redhat.com>
Cc:     kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu,
        drjones@redhat.com, alexandru.elisei@arm.com,
        Paolo Bonzini <pbonzini@redhat.com>, oupton@google.com,
        james.morse@arm.com, suzuki.poulose@arm.com, shuah@kernel.org,
        jingzhangos@google.com, pshier@google.com, rananta@google.com,
        reijiw@google.com
Subject: Re: [PATCH v3 05/10] KVM: arm64: selftests: Make vgic_init gic
 version agnostic
Message-ID: <YVTXDGtocJCXHxKv@google.com>
References: <20210928184803.2496885-1-ricarkol@google.com>
 <20210928184803.2496885-6-ricarkol@google.com>
 <a629c99e-cb41-fb2d-d551-6397774ba765@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a629c99e-cb41-fb2d-d551-6397774ba765@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 29, 2021 at 07:12:59PM +0200, Eric Auger wrote:
> 
> 
> On 9/28/21 8:47 PM, Ricardo Koller wrote:
> > As a preparation for the next commits which will add some tests for
> > GICv2, make aarch64/vgic_init GIC version agnostic. Add a new generic
> > run_tests function(gic_dev_type) that starts all applicable tests using
> > GICv3 or GICv2. GICv2 tests are attempted if GICv3 is not available in
> > the system. There are currently no GICv2 tests, but the test passes now
> > in GICv2 systems.
> >
> > Signed-off-by: Ricardo Koller <ricarkol@google.com>
> > ---
> >  .../testing/selftests/kvm/aarch64/vgic_init.c | 156 +++++++++++-------
> >  1 file changed, 95 insertions(+), 61 deletions(-)
> >
> > diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > index 623f31a14326..896a29f2503d 100644
> > --- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > +++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
> > @@ -22,6 +22,9 @@
> >  
> >  #define GICR_TYPER 0x8
> >  
> > +#define VGIC_DEV_IS_V2(_d) ((_d) == KVM_DEV_TYPE_ARM_VGIC_V2)
> > +#define VGIC_DEV_IS_V3(_d) ((_d) == KVM_DEV_TYPE_ARM_VGIC_V3)
> > +
> >  struct vm_gic {
> >  	struct kvm_vm *vm;
> >  	int gic_fd;
> > @@ -30,8 +33,8 @@ struct vm_gic {
> >  static int max_ipa_bits;
> >  
> >  /* helper to access a redistributor register */
> > -static int access_redist_reg(int gicv3_fd, int vcpu, int offset,
> > -			     uint32_t *val, bool write)
> > +static int access_v3_redist_reg(int gicv3_fd, int vcpu, int offset,
> > +				uint32_t *val, bool write)
> >  {
> >  	uint64_t attr = REG_OFFSET(vcpu, offset);
> >  
> > @@ -58,7 +61,7 @@ static int run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
> >  	return 0;
> >  }
> >  
> > -static struct vm_gic vm_gic_create(void)
> > +static struct vm_gic vm_gic_v3_create(void)
> >  {
> >  	struct vm_gic v;
> >  
> > @@ -80,7 +83,7 @@ static void vm_gic_destroy(struct vm_gic *v)
> >   * device gets created, a legacy RDIST region is set at @0x0
> >   * and a DIST region is set @0x60000
> >   */
> > -static void subtest_dist_rdist(struct vm_gic *v)
> > +static void subtest_v3_dist_rdist(struct vm_gic *v)
> >  {
> >  	int ret;
> >  	uint64_t addr;
> > @@ -145,7 +148,7 @@ static void subtest_dist_rdist(struct vm_gic *v)
> >  }
> >  
> >  /* Test the new REDIST region API */
> > -static void subtest_redist_regions(struct vm_gic *v)
> > +static void subtest_v3_redist_regions(struct vm_gic *v)
> >  {
> >  	uint64_t addr, expected_addr;
> >  	int ret;
> > @@ -249,7 +252,7 @@ static void subtest_redist_regions(struct vm_gic *v)
> >   * VGIC KVM device is created and initialized before the secondary CPUs
> >   * get created
> >   */
> > -static void test_vgic_then_vcpus(void)
> > +static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
> >  {
> >  	struct vm_gic v;
> >  	int ret, i;
> > @@ -257,7 +260,7 @@ static void test_vgic_then_vcpus(void)
> >  	v.vm = vm_create_default(0, 0, guest_code);
> >  	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> >  
> > -	subtest_dist_rdist(&v);
> > +	subtest_v3_dist_rdist(&v);
> >  
> >  	/* Add the rest of the VCPUs */
> >  	for (i = 1; i < NR_VCPUS; ++i)
> > @@ -270,14 +273,14 @@ static void test_vgic_then_vcpus(void)
> >  }
> >  
> >  /* All the VCPUs are created before the VGIC KVM device gets initialized */
> > -static void test_vcpus_then_vgic(void)
> > +static void test_v3_vcpus_then_vgic(uint32_t gic_dev_type)
> >  {
> >  	struct vm_gic v;
> >  	int ret;
> >  
> > -	v = vm_gic_create();
> > +	v = vm_gic_v3_create();
> >  
> > -	subtest_dist_rdist(&v);
> > +	subtest_v3_dist_rdist(&v);
> >  
> >  	ret = run_vcpu(v.vm, 3);
> >  	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
> > @@ -285,15 +288,15 @@ static void test_vcpus_then_vgic(void)
> >  	vm_gic_destroy(&v);
> >  }
> >  
> > -static void test_new_redist_regions(void)
> > +static void test_v3_new_redist_regions(void)
> >  {
> >  	void *dummy = NULL;
> >  	struct vm_gic v;
> >  	uint64_t addr;
> >  	int ret;
> >  
> > -	v = vm_gic_create();
> > -	subtest_redist_regions(&v);
> > +	v = vm_gic_v3_create();
> > +	subtest_v3_redist_regions(&v);
> >  	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
> >  			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> >  
> > @@ -303,8 +306,8 @@ static void test_new_redist_regions(void)
> >  
> >  	/* step2 */
> >  
> > -	v = vm_gic_create();
> > -	subtest_redist_regions(&v);
> > +	v = vm_gic_v3_create();
> > +	subtest_v3_redist_regions(&v);
> >  
> >  	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
> >  	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> > @@ -317,8 +320,8 @@ static void test_new_redist_regions(void)
> >  
> >  	/* step 3 */
> >  
> > -	v = vm_gic_create();
> > -	subtest_redist_regions(&v);
> > +	v = vm_gic_v3_create();
> > +	subtest_v3_redist_regions(&v);
> >  
> >  	_kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> >  			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, dummy, true);
> > @@ -338,7 +341,7 @@ static void test_new_redist_regions(void)
> >  	vm_gic_destroy(&v);
> >  }
> >  
> > -static void test_typer_accesses(void)
> > +static void test_v3_typer_accesses(void)
> >  {
> >  	struct vm_gic v;
> >  	uint64_t addr;
> > @@ -351,12 +354,12 @@ static void test_typer_accesses(void)
> >  
> >  	vm_vcpu_add_default(v.vm, 3, guest_code);
> >  
> > -	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(ret && errno == EINVAL, "attempting to read GICR_TYPER of non created vcpu");
> >  
> >  	vm_vcpu_add_default(v.vm, 1, guest_code);
> >  
> > -	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(ret && errno == EBUSY, "read GICR_TYPER before GIC initialized");
> >  
> >  	vm_vcpu_add_default(v.vm, 2, guest_code);
> > @@ -365,7 +368,7 @@ static void test_typer_accesses(void)
> >  			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
> >  
> >  	for (i = 0; i < NR_VCPUS ; i++) {
> > -		ret = access_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
> > +		ret = access_v3_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
> >  		TEST_ASSERT(!ret && !val, "read GICR_TYPER before rdist region setting");
> >  	}
> >  
> > @@ -374,10 +377,10 @@ static void test_typer_accesses(void)
> >  			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> >  
> >  	/* The 2 first rdists should be put there (vcpu 0 and 3) */
> > -	ret = access_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && !val, "read typer of rdist #0");
> >  
> > -	ret = access_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x310, "read typer of rdist #1");
> >  
> >  	addr = REDIST_REGION_ATTR_ADDR(10, 0x100000, 0, 1);
> > @@ -385,11 +388,11 @@ static void test_typer_accesses(void)
> >  				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> >  	TEST_ASSERT(ret && errno == EINVAL, "collision with previous rdist region");
> >  
> > -	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x100,
> >  		    "no redist region attached to vcpu #1 yet, last cannot be returned");
> >  
> > -	ret = access_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x200,
> >  		    "no redist region attached to vcpu #2, last cannot be returned");
> >  
> > @@ -397,10 +400,10 @@ static void test_typer_accesses(void)
> >  	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> >  			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> >  
> > -	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #1");
> >  
> > -	ret = access_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x210,
> >  		    "read typer of rdist #1, last properly returned");
> >  
> > @@ -417,7 +420,7 @@ static void test_typer_accesses(void)
> >   * rdist region #2 @0x200000 2 rdist capacity
> >   *     rdists: 1, 2
> >   */
> > -static void test_last_bit_redist_regions(void)
> > +static void test_v3_last_bit_redist_regions(void)
> >  {
> >  	uint32_t vcpuids[] = { 0, 3, 5, 4, 1, 2 };
> >  	struct vm_gic v;
> > @@ -444,29 +447,29 @@ static void test_last_bit_redist_regions(void)
> >  	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> >  			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
> >  
> > -	ret = access_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x000, "read typer of rdist #0");
> >  
> > -	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #1");
> >  
> > -	ret = access_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x200, "read typer of rdist #2");
> >  
> > -	ret = access_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x310, "read typer of rdist #3");
> >  
> > -	ret = access_redist_reg(v.gic_fd, 5, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 5, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x500, "read typer of rdist #5");
> >  
> > -	ret = access_redist_reg(v.gic_fd, 4, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 4, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x410, "read typer of rdist #4");
> >  
> >  	vm_gic_destroy(&v);
> >  }
> >  
> >  /* Test last bit with legacy region */
> > -static void test_last_bit_single_rdist(void)
> > +static void test_v3_last_bit_single_rdist(void)
> >  {
> >  	uint32_t vcpuids[] = { 0, 3, 5, 4, 1, 2 };
> >  	struct vm_gic v;
> > @@ -485,28 +488,32 @@ static void test_last_bit_single_rdist(void)
> >  	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
> >  			  KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
> >  
> > -	ret = access_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x000, "read typer of rdist #0");
> >  
> > -	ret = access_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x300, "read typer of rdist #1");
> >  
> > -	ret = access_redist_reg(v.gic_fd, 5, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 5, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x500, "read typer of rdist #2");
> >  
> > -	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #3");
> >  
> > -	ret = access_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
> > +	ret = access_v3_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
> >  	TEST_ASSERT(!ret && val == 0x210, "read typer of rdist #3");
> >  
> >  	vm_gic_destroy(&v);
> >  }
> >  
> > -void test_kvm_device(void)
> > +/*
> > + * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
> > + */
> > +int test_kvm_device(uint32_t gic_dev_type)
> >  {
> >  	struct vm_gic v;
> >  	int ret, fd;
> > +	uint32_t other;
> >  
> >  	v.vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
> >  
> > @@ -514,38 +521,65 @@ void test_kvm_device(void)
> >  	ret = _kvm_create_device(v.vm, 0, true, &fd);
> >  	TEST_ASSERT(ret && errno == ENODEV, "unsupported device");
> >  
> > -	/* trial mode with VGIC_V3 device */
> > -	ret = _kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, true, &fd);
> > -	if (ret) {
> > -		print_skip("GICv3 not supported");
> > -		exit(KSFT_SKIP);
> > -	}
> > -	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
> > +	/* trial mode */
> > +	ret = _kvm_create_device(v.vm, gic_dev_type, true, &fd);
> > +	if (ret)
> > +		return ret;
> > +	v.gic_fd = kvm_create_device(v.vm, gic_dev_type, false);
> > +
> > +	ret = _kvm_create_device(v.vm, gic_dev_type, false, &fd);
> > +	TEST_ASSERT(ret && errno == EEXIST, "create GIC device twice");
> >  
> > -	ret = _kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false, &fd);
> > -	TEST_ASSERT(ret && errno == EEXIST, "create GICv3 device twice");
> > +	kvm_create_device(v.vm, gic_dev_type, true);
> >  
> > -	kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
> > +	/* try to create the other gic_dev_type */
> > +	other = VGIC_DEV_IS_V2(gic_dev_type) ? KVM_DEV_TYPE_ARM_VGIC_V3
> > +					     : KVM_DEV_TYPE_ARM_VGIC_V2;
> >  
> > -	if (!_kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V2, true, &fd)) {
> > -		ret = _kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V2, false, &fd);
> > -		TEST_ASSERT(ret && errno == EINVAL, "create GICv2 while v3 exists");
> > +	if (!_kvm_create_device(v.vm, other, true, &fd)) {
> > +		ret = _kvm_create_device(v.vm, other, false, &fd);
> > +		TEST_ASSERT(ret && errno == EINVAL,
> > +				"create GIC device while other version exists");
> >  	}
> >  
> >  	vm_gic_destroy(&v);
> > +
> > +	return 0;
> > +}
> > +
> > +void run_tests(uint32_t gic_dev_type)
> > +{
> > +	if (VGIC_DEV_IS_V3(gic_dev_type)) {
> > +		test_v3_vcpus_then_vgic(gic_dev_type);
> > +		test_v3_vgic_then_vcpus(gic_dev_type);
> > +		test_v3_new_redist_regions();
> > +		test_v3_typer_accesses();
> > +		test_v3_last_bit_redist_regions();
> > +		test_v3_last_bit_single_rdist();
> > +	}
> >  }
> >  
> >  int main(int ac, char **av)
> >  {
> > +	int ret;
> > +
> >  	max_ipa_bits = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
> >  
> > -	test_kvm_device();
> > -	test_vcpus_then_vgic();
> > -	test_vgic_then_vcpus();
> > -	test_new_redist_regions();
> > -	test_typer_accesses();
> > -	test_last_bit_redist_regions();
> > -	test_last_bit_single_rdist();
> > +	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V3);
> > +	if (!ret) {
> > +		pr_info("Running GIC_v3 tests.\n");
> > +		run_tests(KVM_DEV_TYPE_ARM_VGIC_V3);
> > +		return 0;
> If the GICv3 supports compat with GICv2, I think you could be able to
> run both tests consecutively. So maybe don't return?
> 

Good point, will try that (not returning).

Thanks,
Ricardo

> Besides looks good
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> 
> Eric
> 
> > +	}
> > +
> > +	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V2);
> > +	if (!ret) {
> > +		pr_info("Running GIC_v2 tests.\n");
> > +		run_tests(KVM_DEV_TYPE_ARM_VGIC_V2);
> > +		return 0;
> > +	}
> 
> >  
> > +	print_skip("No GICv2 nor GICv3 support");
> > +	exit(KSFT_SKIP);
> >  	return 0;
> >  }
> 
