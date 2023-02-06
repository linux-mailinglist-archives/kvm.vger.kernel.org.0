Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D215E68C383
	for <lists+kvm@lfdr.de>; Mon,  6 Feb 2023 17:42:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230216AbjBFQmd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Feb 2023 11:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbjBFQmc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Feb 2023 11:42:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026AE279AF
        for <kvm@vger.kernel.org>; Mon,  6 Feb 2023 08:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675701706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3ZLYf3PX0CAzEdb+eEBhMmy2mWJ/blmVpnhmvUTfE2M=;
        b=UZ+uT6FifBR6tMy7lbIPrAxFn9AQk98LU9eLU5zbIIVZ80kT/d/lJoTJ5/cGJqgzXGn///
        ov2oiFqgdvEUC034QAVEmbmrz5iTotqr2HJEMMnXQ5Kn0RqBbjhPPU4zj1awOFXQCECrtj
        yHK3dOKeXh6cgR5RC8GGMqhFZDVeDlA=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-149-3JBlDAU1OuedaV-ApOxlIg-1; Mon, 06 Feb 2023 11:41:42 -0500
X-MC-Unique: 3JBlDAU1OuedaV-ApOxlIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8261F3847980;
        Mon,  6 Feb 2023 16:41:41 +0000 (UTC)
Received: from localhost (dhcp-192-239.str.redhat.com [10.33.192.239])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 237B940CF8E2;
        Mon,  6 Feb 2023 16:41:35 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Richard Henderson <richard.henderson@linaro.org>,
        Peter Maydell <peter.maydell@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>
Cc:     qemu-arm@nongnu.org, qemu-devel@nongnu.org, kvm@vger.kernel.org,
        Eric Auger <eauger@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Juan Quintela <quintela@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: Re: [PATCH v5 2/3] arm/kvm: add support for MTE
In-Reply-To: <da118de5-adcd-ec0c-9870-454c3741a4ab@linaro.org>
Organization: Red Hat GmbH
References: <20230203134433.31513-1-cohuck@redhat.com>
 <20230203134433.31513-3-cohuck@redhat.com>
 <da118de5-adcd-ec0c-9870-454c3741a4ab@linaro.org>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Mon, 06 Feb 2023 17:41:33 +0100
Message-ID: <874jryn3uq.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 03 2023, Richard Henderson <richard.henderson@linaro.org> wrote:

> On 2/3/23 03:44, Cornelia Huck wrote:
>> +static inline bool arm_machine_has_tag_memory(void)
>> +{
>> +#ifndef CONFIG_USER_ONLY
>> +    Object *obj = object_dynamic_cast(qdev_get_machine(), TYPE_VIRT_MACHINE);
>> +
>> +    /* so far, only the virt machine has support for tag memory */
>> +    if (obj) {
>> +        VirtMachineState *vms = VIRT_MACHINE(obj);
>
> VIRT_MACHINE() does object_dynamic_cast_assert, and we've just done that.
>
> As this is startup, it's not the speed that matters.  But it does look unfortunate.  Not 
> for this patch set, but perhaps we ought to add TRY_OBJ_NAME to DECLARE_INSTANCE_CHECKER?

Instead of the pattern above, we could also do

VirtMachineState *vms = (VirtMachineState *) object_dynamic_cast(...);
if (vms) {
(...)


>
>> +void arm_cpu_mte_finalize(ARMCPU *cpu, Error **errp)
>> +{
>> +    bool enable_mte;
>> +
>> +    switch (cpu->prop_mte) {
>> +    case ON_OFF_AUTO_OFF:
>> +        enable_mte = false;
>> +        break;
>> +    case ON_OFF_AUTO_ON:
>> +        if (tcg_enabled()) {
>> +            if (cpu_isar_feature(aa64_mte, cpu)) {
>> +                if (!arm_machine_has_tag_memory()) {
>> +                    error_setg(errp, "mte=on requires tag memory");
>> +                    return;
>> +                }
>> +            } else {
>> +                error_setg(errp, "mte not supported by this CPU type");
>> +                return;
>> +            }
>> +        }
>> +        if (kvm_enabled() && !kvm_arm_mte_supported()) {
>> +            error_setg(errp, "mte not supported by kvm");
>> +            return;
>> +        }
>> +        enable_mte = true;
>> +        break;
>
> What's here is not wrong, but maybe better structured as
>
> 	enable_mte = true;
>          if (qtest_enabled()) {
>              break;
>          }
>          if (tcg_enabled()) {
>              if (arm_machine_tag_mem) {
>                  break;
>              }
>              error;
>              return;
>          }
>          if (kvm_enabled() && kvm_arm_mte_supported) {
>              break;
>          }
>          error("mte not supported by %s", current_accel_type());
>          return;

That's indeed better, as we also see what's going on for the different
accelarators.

> We only add the property for tcg via -cpu max, so the isar check is redundant.

