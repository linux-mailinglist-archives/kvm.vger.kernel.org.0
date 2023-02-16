Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A760698E32
	for <lists+kvm@lfdr.de>; Thu, 16 Feb 2023 08:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjBPH7W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Feb 2023 02:59:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjBPH7V (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Feb 2023 02:59:21 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B311EC7B
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 23:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676534314;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eQOjVsFCow0A7sQ5eVwn9Fx+XiRjrGdejeIN4EGNxn4=;
        b=f1KqFO/aOVibGE7YWpV6nAwq/Jd0XgumxUOhG2JdohQsii3gzii2Ati4IMKHYSDnGEhZt9
        rW4Kc3v0NtDo4/MH26FgtytkSwhjRhPUonm+k6m3FfzGgZrRQ3JQD6cSAcGc94SY/5Vxp4
        GhcCaK+7EUbiNlXEjl/XOVflBTxqSMA=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-84--KcPXUwzP-iVHj1HwxsfjA-1; Thu, 16 Feb 2023 02:58:33 -0500
X-MC-Unique: -KcPXUwzP-iVHj1HwxsfjA-1
Received: by mail-qk1-f197.google.com with SMTP id g6-20020ae9e106000000b00720f9e6e3e2so734176qkm.13
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 23:58:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eQOjVsFCow0A7sQ5eVwn9Fx+XiRjrGdejeIN4EGNxn4=;
        b=MfFRSsPZY4b3aGCSq5c2J+ZaKrGwg3OqAbdc2U3j+vmLSnp3jkml0KBQvRHrSbBV/L
         XNXUMtyS7n+BEYZie12JfS98gq3S1YqeTsaKkqemfCNh6xP3QqBKFaYGqcyASLpemBf+
         g248Pvhca7OlzhdFtRVdZeWNssGrxelUrLP94H8p5ajUbpfd45PiXlI72b6jR76CRNxA
         tlcWxr7a6mF4EkQr/NvZEL7bkGcCB9kwzant16Sr+wnvxdJN+k7iQrPX26WJpEgcGdz6
         jyuxPgckVW21s0575g0lVP7izg3xgNFK4f5AQhj738Fo9pjBfJKE1qdww6jhR8/boO+2
         9HYA==
X-Gm-Message-State: AO0yUKUC4pGmzUboeeNZl+uUu3G4PjWkS/3RuOG9UhP/xIxau3ZTXj8i
        a3h0p98QFRm80ak4X5N+g0DzpAwFNLseaMNEVs8xAs/BmCdWd9yE1/JoEaiwt1DaJT0pJ1zXFMO
        S+9/60fjGIX8F
X-Received: by 2002:ac8:7d06:0:b0:3b8:6c10:f52 with SMTP id g6-20020ac87d06000000b003b86c100f52mr9108817qtb.46.1676534312521;
        Wed, 15 Feb 2023 23:58:32 -0800 (PST)
X-Google-Smtp-Source: AK7set8cSqYROssY81qYk1tIYDpeDpcutDsT3ukmfNWC6FjE0fX7JbR/tBo3b/veb7UgJW0FBStazQ==
X-Received: by 2002:ac8:7d06:0:b0:3b8:6c10:f52 with SMTP id g6-20020ac87d06000000b003b86c100f52mr9108798qtb.46.1676534312229;
        Wed, 15 Feb 2023 23:58:32 -0800 (PST)
Received: from ?IPV6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id s64-20020a372c43000000b00719165e9e72sm689993qkh.91.2023.02.15.23.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Feb 2023 23:58:31 -0800 (PST)
Message-ID: <240d4842-5f71-bf51-6a7c-845c70ce0abd@redhat.com>
Date:   Thu, 16 Feb 2023 08:58:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Reply-To: eric.auger@redhat.com
Subject: Re: [RFC v3 14/18] backends/iommufd: Introduce the iommufd object
Content-Language: en-US
To:     Nicolin Chen <nicolinc@nvidia.com>
Cc:     eric.auger.pro@gmail.com, yi.l.liu@intel.com, yi.y.sun@intel.com,
        alex.williamson@redhat.com, clg@redhat.com, qemu-devel@nongnu.org,
        david@gibson.dropbear.id.au, thuth@redhat.com,
        farman@linux.ibm.com, mjrosato@linux.ibm.com,
        akrowiak@linux.ibm.com, pasic@linux.ibm.com, jjherne@linux.ibm.com,
        jasowang@redhat.com, kvm@vger.kernel.org, jgg@nvidia.com,
        kevin.tian@intel.com, chao.p.peng@intel.com, peterx@redhat.com,
        shameerali.kolothum.thodi@huawei.com, zhangfei.gao@linaro.org,
        berrange@redhat.com, apopple@nvidia.com,
        suravee.suthikulpanit@amd.com
References: <20230131205305.2726330-1-eric.auger@redhat.com>
 <20230131205305.2726330-15-eric.auger@redhat.com>
 <Y+1vNgoGJJw40+9C@Asurada-Nvidia>
From:   Eric Auger <eric.auger@redhat.com>
In-Reply-To: <Y+1vNgoGJJw40+9C@Asurada-Nvidia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Nicolin,

On 2/16/23 00:48, Nicolin Chen wrote:
> Hi Eric,
>
> On Tue, Jan 31, 2023 at 09:53:01PM +0100, Eric Auger wrote:
>
>> diff --git a/include/sysemu/iommufd.h b/include/sysemu/iommufd.h
>> new file mode 100644
>> index 0000000000..06a866d1bd
>> --- /dev/null
>> +++ b/include/sysemu/iommufd.h
>> @@ -0,0 +1,47 @@
>> +#ifndef SYSEMU_IOMMUFD_H
>> +#define SYSEMU_IOMMUFD_H
>> +
>> +#include "qom/object.h"
>> +#include "qemu/thread.h"
>> +#include "exec/hwaddr.h"
>> +#include "exec/ram_addr.h"
> After rebasing nesting patches on top of this, I see a build error:
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> [47/876] Compiling C object libcommon.fa.p/hw_arm_smmu-common.c.o
> FAILED: libcommon.fa.p/hw_arm_smmu-common.c.o=20
> cc -Ilibcommon.fa.p -I../src/3rdparty/qemu/dtc/libfdt -I/usr/include/pi=
xman-1 -I/usr/include/libmount -I/usr/include/blkid -I/usr/include/glib-2=
=2E0 -I/usr/lib/aarch64-linux-gnu/glib-2.0/include -I/usr/include/gio-uni=
x-2.0 -fdiagnostics-color=3Dauto -Wall -Winvalid-pch -std=3Dgnu11 -O2 -g =
-isystem /src/3rdparty/qemu/linux-headers -isystem linux-headers -iquote =
=2E -iquote /src/3rdparty/qemu -iquote /src/3rdparty/qemu/include -iquote=
 /src/3rdparty/qemu/tcg/aarch64 -pthread -U_FORTIFY_SOURCE -D_FORTIFY_SOU=
RCE=3D2 -D_GNU_SOURCE -D_FILE_OFFSET_BITS=3D64 -D_LARGEFILE_SOURCE -fno-s=
trict-aliasing -fno-common -fwrapv -Wundef -Wwrite-strings -Wmissing-prot=
otypes -Wstrict-prototypes -Wredundant-decls -Wold-style-declaration -Wol=
d-style-definition -Wtype-limits -Wformat-security -Wformat-y2k -Winit-se=
lf -Wignored-qualifiers -Wempty-body -Wnested-externs -Wendif-labels -Wex=
pansion-to-defined -Wimplicit-fallthrough=3D2 -Wmissing-format-attribute =
-Wno-missing-include-dirs -Wno-shift-negative-value -Wno-psabi -fstack-pr=
otector-strong -fPIE -MD -MQ libcommon.fa.p/hw_arm_smmu-common.c.o -MF li=
bcommon.fa.p/hw_arm_smmu-common.c.o.d -o libcommon.fa.p/hw_arm_smmu-commo=
n.c.o -c ../src/3rdparty/qemu/hw/arm/smmu-common.c
> In file included from /src/3rdparty/qemu/include/sysemu/iommufd.h:7,
>                  from ../src/3rdparty/qemu/hw/arm/smmu-common.c:29:
> /src/3rdparty/qemu/include/exec/ram_addr.h:23:10: fatal error: cpu.h: N=
o such file or directory
>    23 | #include "cpu.h"
>       |          ^~~~~~~
> compilation terminated.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> I guess it's resulted from the module inter-dependency. Though our
> nesting patches aren't finalized yet, the possibility of including
> iommufd.h is still there. Meanwhile, the ram_addr.h here is added
> for "ram_addr_t" type, I think. So, could we include "cpu-common.h"
> instead, where the "ram_addr_t" type is actually defined?

Sure. We will fix that on the next iteration

Eric

>
> The build error is gone after this replacement:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/include/sysemu/iommufd.h b/include/sysemu/iommufd.h
> index 45540de63986..86d370c221b3 100644
> --- a/include/sysemu/iommufd.h
> +++ b/include/sysemu/iommufd.h
> @@ -4,7 +4,7 @@
>  #include "qom/object.h"
>  #include "qemu/thread.h"
>  #include "exec/hwaddr.h"
> -#include "exec/ram_addr.h"
> +#include "exec/cpu-common.h"
>  #include <linux/iommufd.h>
> =20
>  #define TYPE_IOMMUFD_BACKEND "iommufd"
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> Thanks
> Nic
>

