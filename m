Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45CC97CDBE2
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 14:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344643AbjJRMgJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 08:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344518AbjJRMgF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 08:36:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E28298
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 05:35:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697632522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Lz7XMhYS02Gm6gaNbc9MQCWSsb5Mo/qLQc74Gx24w/Y=;
        b=TJLaenT5Dyu17fEVJTdXHfuOipi/sQapsreny1lVCX3x6PGvec87XUUKow1ETcMLJr6Atm
        EkEpQJp4RYo2FQIlKMUZrmHECmYlHeIrcO7rDrvh0nDYr8RBBOGkNWbudux0z0zcZU4+vh
        Z3LIzm8PtpcuL+3Z+krQkhfJ6Ndc6C0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-665-S5U5UdzuNTiPHi-fdTr-cw-1; Wed, 18 Oct 2023 08:35:05 -0400
X-MC-Unique: S5U5UdzuNTiPHi-fdTr-cw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E544C886C62;
        Wed, 18 Oct 2023 12:35:03 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5055B2166B28;
        Wed, 18 Oct 2023 12:35:03 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-perf-users@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Jing Zhang <jingzhangos@google.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        James Morse <james.morse@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ian Rogers <irogers@google.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 5/5] KVM: arm64: selftests: Test for setting ID
 register from usersapce
In-Reply-To: <ZS4_wGJPg3G8dA7Z@linux.dev>
Organization: "Red Hat GmbH, Sitz: Werner-von-Siemens-Ring 12, D-85630
 Grasbrunn, Handelsregister: Amtsgericht =?utf-8?Q?M=C3=BCnchen=2C?= HRB
 153243,
 =?utf-8?Q?Gesch=C3=A4ftsf=C3=BChrer=3A?= Ryan Barnhart, Charles Cachera,
 Michael O'Neill, Amy
 Ross"
References: <20231011195740.3349631-1-oliver.upton@linux.dev>
 <20231011195740.3349631-6-oliver.upton@linux.dev>
 <87fs2aegap.fsf@redhat.com> <ZS4_wGJPg3G8dA7Z@linux.dev>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Wed, 18 Oct 2023 14:35:02 +0200
Message-ID: <87mswgcdmx.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Oct 17 2023, Oliver Upton <oliver.upton@linux.dev> wrote:

> On Mon, Oct 16, 2023 at 05:30:06PM +0200, Cornelia Huck wrote:
>> On Wed, Oct 11 2023, Oliver Upton <oliver.upton@linux.dev> wrote:
>> 
>> > From: Jing Zhang <jingzhangos@google.com>
>> >
>> > Add tests to verify setting ID registers from userspace is handled
>> > correctly by KVM. Also add a test case to use ioctl
>> > KVM_ARM_GET_REG_WRITABLE_MASKS to get writable masks.
>> >
>> > Signed-off-by: Jing Zhang <jingzhangos@google.com>
>> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
>> > ---
>> >  tools/testing/selftests/kvm/Makefile          |   1 +
>> >  .../selftests/kvm/aarch64/set_id_regs.c       | 479 ++++++++++++++++++
>> >  2 files changed, 480 insertions(+)
>> >  create mode 100644 tools/testing/selftests/kvm/aarch64/set_id_regs.c
>> 
>> (...)
>> 
>> > +static void test_user_set_reg(struct kvm_vcpu *vcpu, bool aarch64_only)
>> > +{
>> > +	uint64_t masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
>> > +	struct reg_mask_range range = {
>> > +		.addr = (__u64)masks,
>> > +	};
>> > +	int ret;
>> > +
>> > +	/* KVM should return error when reserved field is not zero */
>> > +	range.reserved[0] = 1;
>> > +	ret = __vm_ioctl(vcpu->vm, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
>> > +	TEST_ASSERT(ret, "KVM doesn't check invalid parameters.");
>> 
>> I think the code should first check for
>> KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES -- newer kselftests are supposed
>> to be able to run on older kernels, and we should just skip all of this
>> if the API isn't there.
>
> Ah, thanks! I'll apply the following on top:
>
> diff --git a/tools/testing/selftests/kvm/aarch64/set_id_regs.c b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> index 5c0718fd1705..bac05210b539 100644
> --- a/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> +++ b/tools/testing/selftests/kvm/aarch64/set_id_regs.c
> @@ -452,6 +452,8 @@ int main(void)
>  	uint64_t val, el0;
>  	int ftr_cnt;
>  
> +	TEST_REQUIRE(kvm_has_cap(KVM_CAP_ARM_SUPPORTED_REG_MASK_RANGES));
> +
>  	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
>  
>  	/* Check for AARCH64 only system */

Thanks, LGTM.

