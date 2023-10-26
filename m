Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEB117D8187
	for <lists+kvm@lfdr.de>; Thu, 26 Oct 2023 13:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344748AbjJZLHg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Oct 2023 07:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344699AbjJZLHe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Oct 2023 07:07:34 -0400
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9971A2
        for <kvm@vger.kernel.org>; Thu, 26 Oct 2023 04:07:32 -0700 (PDT)
Date:   Thu, 26 Oct 2023 13:07:28 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1698318450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GTizDwaFqeSYDTa6kgZ/sR4mN6UauDoNIA8sRDmavHw=;
        b=s0BWalfU3x+rCXDaIa4DTjlveSs3gpW6ZHNSyHWDOeZCOs7caMFRo1h5Ck3Km7IRL4IK5f
        Reqv7P0uHrndKGe5e7a+otBHm2Lx9ttFOuu6wj+61iLVSorcph2mnc+1ZogdSXjLiFy85r
        qWH9L59CfIpmf9BBwlBjTtx9fjPiMpI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     Thomas Huth <thuth@redhat.com>, kvmarm@lists.linux.dev,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Ricardo Koller <ricarkol@google.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1] configure: arm64: Add support for
 dirty-ring in migration
Message-ID: <20231026-b6fc2692a0fe4a0415451781@orel>
References: <20231026034042.812006-1-shahuang@redhat.com>
 <e318cd46-b871-448a-b95a-01647d8afc43@redhat.com>
 <9052ed87-e5cf-4d89-b480-54da4d8216c7@redhat.com>
 <20231026-38a5f6360752b10fdb086adc@orel>
 <907d8b7a-2cb0-f5b4-ac54-51aa1f6dd540@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <907d8b7a-2cb0-f5b4-ac54-51aa1f6dd540@redhat.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 26, 2023 at 04:44:26PM +0800, Shaoqin Huang wrote:
> Hi drew,
> 
> On 10/26/23 15:40, Andrew Jones wrote:
> > On Thu, Oct 26, 2023 at 01:54:55PM +0800, Shaoqin Huang wrote:
> > > 
> > > 
> > > On 10/26/23 13:12, Thomas Huth wrote:
> > > > On 26/10/2023 05.40, Shaoqin Huang wrote:
> > > > > Add a new configure option "--dirty-ring-size" to support dirty-ring
> > > > > migration on arm64. By default, the dirty-ring is disabled, we can
> > > > > enable it by:
> > > > > 
> > > > >     # ./configure --dirty-ring-size=65536
> > > > > 
> > > > > This will generate one more entry in config.mak, it will look like:
> > > > > 
> > > > >     # cat config.mak
> > > > >       :
> > > > >     ACCEL=kvm,dirty-ring-size=65536
> > > > > 
> > > > > With this configure option, user can easy enable dirty-ring and specify
> > > > > dirty-ring-size to test the dirty-ring in migration.
> > > > 
> > > > Do we really need a separate configure switch for this? If it is just
> > > > about setting a value in the ACCEL variable, you can also run the tests
> > > > like this:
> > > > 
> > > > ACCEL=kvm,dirty-ring-size=65536 ./run_tests.sh
> > > > 
> > > >    Thomas
> > > > 
> > > 
> > > Hi Thomas,
> > > 
> > > You're right. We can do it by simply set the ACCEL when execute
> > > ./run_tests.sh. I think maybe add a configure can make auto test to set the
> > > dirty-ring easier? but I'm not 100% sure it will benefit to them.
> > > 
> > 
> > For unit tests that require specific configurations, those configurations
> > should be added to the unittests.cfg file. As we don't currently support
> > adding accel properties, we should add a new parameter and extend the
> > parsing.
> 
> So you mean we add the accel properties into the unittests.cfg like:
> 
> accel = kvm,dirty-ring-size=65536
> 
> Then let the `for_each_unittest` to parse the parameter?
> In this way, should we copy the migration config to dirty-ring migration?
> Just like:
> 
> [its-migration]
> file = gic.flat
> smp = $MAX_SMP
> extra_params = -machine gic-version=3 -append 'its-migration'
> groups = its migration
> arch = arm64
> 
> [its-migration-dirty-ring]
> file = gic.flat
> smp = $MAX_SMP
> extra_params = -machine gic-version=3 -append 'its-migration'
> groups = its migration
> arch = arm64
> accel = kvm,dirty-ring-size=65536
> 
> So it will test both dirty bitmap and dirty ring.

Yup, either like you've outlined above with modifying the definition of
'accel' to take an optional [,params...] or by creating another parameter,
e.g. 'accel_props' and then doing

 accel = kvm
 accel_props = dirty-ring-size=65536

Which of the two approaches to choose depends on how intrusive the
modification of 'accel' would be and how well it would preserve its
current behavior.

Thanks,
drew
