Return-Path: <kvm+bounces-13049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E313B891228
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 04:45:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 986DE28A0AA
	for <lists+kvm@lfdr.de>; Fri, 29 Mar 2024 03:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 729263AC08;
	Fri, 29 Mar 2024 03:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dCU36y7N"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9013A267
	for <kvm@vger.kernel.org>; Fri, 29 Mar 2024 03:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711683932; cv=none; b=alselmv/7M1DUU7id9EtdHpNo0KL/8cWyEOjyz9la2oLsLG4QSv++BNm27KoJfuytKKmcOTfYzQL0FfmWm0n8D8bbAVyFXCyXsM6M2NydCXF0AcmnBP/JhCv+4kt7ShWjyo6GkfWUm7yR2IgGFs4hY/6YbLgZNl3Vnb4au5QE3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711683932; c=relaxed/simple;
	bh=wmY6RiQioAvyVbD8E9OBDOsNZRJ8tTFYb6nIY+BfuUM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KHGK1c512q2rqqe/eAk0/rQd5MihIipoxrpg+Ly526VhpIdMHXinrMkpEO4A0vTOOjXpS+8s0z6i4V7baNRNDme8/MPp7lKYxSU9c4MdTuwjsbOBVrk3dqWFmGioC+5K1y9prkkzKSVU8gASMdw/irBI9JH7tWlEMxGkKk3CpTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=dCU36y7N; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1711683929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VdyyTcNkDbQcMt3hk5T8AQVMtPVQqupjlUcIYRBR2cI=;
	b=dCU36y7NvTnE5augfA3W7CS6KSAkvr9nRwm4GN97FMGQlh+QEkrkMuri3NSd+/56znipsc
	gtDyEg1wB5kouZPjO1XR8oBLGJxV2vOsSK5csoAFoGWvcQW4blFy79uHBFsVrFQRJqROlG
	01zVEsIpObbb0nEhsZHxzHyN3LbCoPU=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-0uba5pBbNu2gWPfkXuSyzg-1; Thu, 28 Mar 2024 23:45:26 -0400
X-MC-Unique: 0uba5pBbNu2gWPfkXuSyzg-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-6dbd919aba8so316767b3a.0
        for <kvm@vger.kernel.org>; Thu, 28 Mar 2024 20:45:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711683926; x=1712288726;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VdyyTcNkDbQcMt3hk5T8AQVMtPVQqupjlUcIYRBR2cI=;
        b=A6PLByE+AIdCJXO/16gQKPRwAYWm2vwfeUcrH3+06hRsY3eeHDSaBPkNjHyW2K7WW6
         J3pxrJEZZIXlHdcNsijJSybarhN1zqhYlF3DRM8clDGV9h8MdEeVWGRQnroNk3CRdRVd
         vPTzp9JeiIu0xnLlqDkItsSY4SeMvR2boFI7Na2L6MK8uWM8Vwgnp1pCF2UwYKCVEACT
         5Dy2JnMElK0X5JOGCrJOm1ELenmJiGnQ/QlUptefo9KHsjgBZHn3qLvdDrIvOx3YBSqy
         HiXU971+1i1oJyXBYnt4t7XYteYkXGS8lf54DrXfnQMm/dLMbQxKSDyLn3bo0e60RvdR
         bnVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXaS4OQ3MdhoLpK8vmPJUP56bVNZUFqw7eRbAL75u0YtF26Uqr9STw63ev9ePgfOBc6nNBKumZS4dCcaykCXFq22GDX
X-Gm-Message-State: AOJu0YwM/mLwDcH/xCxwGIoF95TrrUbAhjEkVwXgwFHFPz2OFv/SEFko
	iHbxcpKwGm2GTqRcZNtq2o2JgDgbWXIFs2S6ZzeWSsn+R18jZdfeKCe9MLe9gE2b/cN4dNvNgJG
	mtHXTlpiVmY2yydo0kP8CESg4mLjXZ+uzCiKZQPpXCxj1FtX6Fg==
X-Received: by 2002:a05:6a00:198c:b0:6ea:ba47:a63b with SMTP id d12-20020a056a00198c00b006eaba47a63bmr1333603pfl.0.1711683925726;
        Thu, 28 Mar 2024 20:45:25 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG1FoE+ZIDAuKnYBSfurhdchpwpXgjke0/t+cMdsPn4minv8qJYLVuVrOZjJLrfqTLVOTmrCQ==
X-Received: by 2002:a05:6a00:198c:b0:6ea:ba47:a63b with SMTP id d12-20020a056a00198c00b006eaba47a63bmr1333592pfl.0.1711683925418;
        Thu, 28 Mar 2024 20:45:25 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id e5-20020aa79805000000b006eac9c54f7csm2197966pfl.96.2024.03.28.20.45.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Mar 2024 20:45:25 -0700 (PDT)
Message-ID: <46f0c5ab-dee7-4cd4-844d-c418818e187c@redhat.com>
Date: Fri, 29 Mar 2024 11:45:21 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] arm/kvm: Enable support for KVM_ARM_VCPU_PMU_V3_FILTER
To: =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>
Cc: qemu-arm@nongnu.org, Eric Auger <eauger@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Huth <thuth@redhat.com>,
 Laurent Vivier <lvivier@redhat.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Kevin Wolf <kwolf@redhat.com>
References: <20240312074849.71475-1-shahuang@redhat.com>
 <Zf2bbcpWYMWKZpNy@redhat.com>
 <1881554f-9183-4e01-8cda-0934f7829abf@redhat.com>
 <ZgE71v8uGDNihQ5H@redhat.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <ZgE71v8uGDNihQ5H@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Daniel,

On 3/25/24 16:55, Daniel P. Berrangé wrote:
> On Mon, Mar 25, 2024 at 01:35:58PM +0800, Shaoqin Huang wrote:
>> Hi Daniel,
>>
>> Thanks for your reviewing. I see your comments in the v7.
>>
>> I have some doubts about what you said about the QAPI. Do you want me to
>> convert the current design into the QAPI parsing like the
>> IOThreadVirtQueueMapping? And we need to add new json definition in the
>> qapi/ directory?

I have defined the QAPI for kvm-pmu-filter like below:

+##
+# @FilterAction:
+#
+# The Filter Action
+#
+# @a: Allow
+#
+# @d: Disallow
+#
+# Since: 9.0
+##
+{ 'enum': 'FilterAction',
+  'data': [ 'a', 'd' ] }
+
+##
+# @SingleFilter:
+#
+# Lazy
+#
+# @action: the action
+#
+# @start: the start
+#
+# @end: the end
+#
+# Since: 9.0
+##
+
+{ 'struct': 'SingleFilter',
+ 'data': { 'action': 'FilterAction', 'start': 'int', 'end': 'int' } }
+
+##
+# @KVMPMUFilter:
+#
+# Lazy
+#
+# @filter: the filter
+#
+# Since: 9.0
+##
+
+{ 'struct': 'KVMPMUFilter',
+  'data': { 'filter': ['SingleFilter'] }}

And I guess I can use it by adding code like below:

--- a/hw/core/qdev-properties-system.c
+++ b/hw/core/qdev-properties-system.c
@@ -1206,3 +1206,35 @@ const PropertyInfo 
qdev_prop_iothread_vq_mapping_list = {
      .set = set_iothread_vq_mapping_list,
      .release = release_iothread_vq_mapping_list,
  };
+
+/* --- kvm-pmu-filter ---*/
+
+static void get_kvm_pmu_filter(Object *obj, Visitor *v,
+        const char *name, void *opaque, Error **errp)
+{
+    KVMPMUFilter **prop_ptr = object_field_prop_ptr(obj, opaque);
+
+    visit_type_KVMPMUFilter(v, name, prop_ptr, errp);
+}
+
+static void set_kvm_pmu_filter(Object *obj, Visitor *v,
+        const char *name, void *opaque, Error **errp)
+{
+    KVMPMUFilter **prop_ptr = object_field_prop_ptr(obj, opaque);
+    KVMPMUFilter *list;
+
+    printf("running the %s\n", __func__);
+    if (!visit_type_KVMPMUFilter(v, name, &list, errp)) {
+        return;
+    }
+
+    printf("The name is %s\n", name);
+    *prop_ptr = list;
+}
+
+const PropertyInfo qdev_prop_kvm_pmu_filter = {
+    .name = "KVMPMUFilter",
+    .description = "der der",
+    .get = get_kvm_pmu_filter,
+    .set = set_kvm_pmu_filter,
+};

+#define DEFINE_PROP_KVM_PMU_FILTER(_name, _state, _field) \
+    DEFINE_PROP(_name, _state, _field, qdev_prop_kvm_pmu_filter, \
+                KVMPMUFilter *)

--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -2439,6 +2441,7 @@ static Property arm_cpu_properties[] = {
                          mp_affinity, ARM64_AFFINITY_INVALID),
      DEFINE_PROP_INT32("node-id", ARMCPU, node_id, CPU_UNSET_NUMA_NODE_ID),
      DEFINE_PROP_INT32("core-count", ARMCPU, core_count, -1),
+    DEFINE_PROP_KVM_PMU_FILTER("kvm-pmu-filter", ARMCPU, kvm_pmu_filter),
      DEFINE_PROP_END_OF_LIST()
  };

And I guess I can use the new json format input like below:

qemu-system-aarch64 \
	-cpu host, '{"filter": [{"action": "a", "start": 0x10, "end": "0x11"}]}'

But it doesn't work. It seems like because the -cpu option doesn't 
support json format parameter.

Maybe I'm wrong. So I want to double check with if the -cpu option 
support json format nowadays?

If the -cpu option doesn't support json format, how I can use the QAPI 
for kvm-pmu-filter property?

Thanks,
Shaoqin

> 
> Yes, you would define a type in the qapi dir similar to how is
> done for IOThreadVirtQueueMapping, and then you can use that
> in the property setter method.
> 
> 
> With regards,
> Daniel

-- 
Shaoqin


