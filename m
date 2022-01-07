Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E91487B0F
	for <lists+kvm@lfdr.de>; Fri,  7 Jan 2022 18:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348497AbiAGRK6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jan 2022 12:10:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:33371 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229546AbiAGRK4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 7 Jan 2022 12:10:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1641575456;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3pHZETgLBLv2UtRUl6D+BkLJ1jpxDMC+Tp9BPH2rI4Y=;
        b=VDg0JEqBzEMGlLugndz7XDAOETZ40+sVozTVhsW2IH+hjO3oXK3rNTMDh1+tdgyTTAHRoL
        dYfjk+SQqDmwzYF5edEVXxZw6AVCMdAmb6UN/fi72jaenFP+gmeLj4hARi7cbgldyEC9c0
        fkJ+H0AY3VZXwGvmM5k+ZnjzDaNarUM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-669-GRdqBEW4MiWz625wwmGmDQ-1; Fri, 07 Jan 2022 12:10:55 -0500
X-MC-Unique: GRdqBEW4MiWz625wwmGmDQ-1
Received: by mail-wm1-f70.google.com with SMTP id s190-20020a1ca9c7000000b00347c6c39d9aso828211wme.5
        for <kvm@vger.kernel.org>; Fri, 07 Jan 2022 09:10:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=3pHZETgLBLv2UtRUl6D+BkLJ1jpxDMC+Tp9BPH2rI4Y=;
        b=KZBLtrpBjR3v1pIfdRHqaj3ZvOVHwdhLgjkN7yzeoev/MOxZulk9Iir6h3V85nESck
         6SpVmh+KOCMgDr0EP++dzsbZeJp/6jMF1SfYUjoksUynKwYt1vN9kZ4SvtvGY9yf0LeG
         UoTFrxGLhm8Zj64CRDNqqUxDjMc4iCy10sLGBf4kZGbECSSI79dRJ8Y9naCJxLk0mQBo
         swUcYl7c7O88FEkl4k5EKWtDZsvKXEdlkXxZYSvinN5fZ4aHimtMFQCCXOwfimiYwsgx
         XKlLZAjI+m9ionCUaHfagiTV1bD1QrYAhcfrzFzD1ayw2Ykk3OXiUqH/J6/X4UlkvY5+
         vLww==
X-Gm-Message-State: AOAM531hl+buaudy6opBix6iGZjdN0ZdDuS5MwzqJUrs+IQfV6Sw1qo5
        Sdbie6440j+aK9RFwXOYUq2DOqxCNhB27R0BV/KhihvuMzKK2uCzYhP2SE1Muk5shpHafAtpotC
        K7V5/SrNrz/1+
X-Received: by 2002:a05:6000:1e07:: with SMTP id bj7mr5846334wrb.126.1641575453603;
        Fri, 07 Jan 2022 09:10:53 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx9B+o3El0zBY9MRT5nLG9njMtu1q5Pq4PQVdvKApvURcNkIL2mU6w3Vbnbe92sMBLQ4jEp8A==
X-Received: by 2002:a05:6000:1e07:: with SMTP id bj7mr5846317wrb.126.1641575453396;
        Fri, 07 Jan 2022 09:10:53 -0800 (PST)
Received: from ?IPv6:2a01:e0a:59e:9d80:527b:9dff:feef:3874? ([2a01:e0a:59e:9d80:527b:9dff:feef:3874])
        by smtp.gmail.com with ESMTPSA id p23sm5013096wms.3.2022.01.07.09.10.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Jan 2022 09:10:52 -0800 (PST)
Reply-To: eric.auger@redhat.com
Subject: Re: [PATCH v2 1/5] hw/arm/virt: Key enablement of highmem PCIe on
 highmem_ecam
To:     Marc Zyngier <maz@kernel.org>
Cc:     qemu-devel@nongnu.org, Andrew Jones <drjones@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel-team@android.com
References: <20211003164605.3116450-1-maz@kernel.org>
 <20211003164605.3116450-2-maz@kernel.org>
 <dbe883ca-880e-7f2b-1de7-4b2d3361545d@redhat.com>
 <87pmpiyrfw.wl-maz@kernel.org>
 <b9031d40-897e-b8c5-4240-fc2936dcbcb9@redhat.com>
 <877dbfywpj.wl-maz@kernel.org>
 <cb9f6c39-40f8-eea7-73bf-13df1e5dae9d@redhat.com>
 <8735m0zmhq.wl-maz@kernel.org>
From:   Eric Auger <eric.auger@redhat.com>
Message-ID: <44fcbe49-4eb2-8891-2cb9-2e2df7dee98b@redhat.com>
Date:   Fri, 7 Jan 2022 18:10:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <8735m0zmhq.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 1/6/22 8:34 PM, Marc Zyngier wrote:
> Hi Eric,
>
> On Wed, 05 Jan 2022 09:41:19 +0000,
> Eric Auger <eric.auger@redhat.com> wrote:
>> couldn't you simply introduce highmem_redist which is truly missing. You
>> could set it in virt_set_memmap() in case you skip extended_map overlay
>> and use it in virt_gicv3_redist_region_count() as you did?
>> In addition to the device memory top address check against the 4GB limit
>> if !highmem, we should be fine then?
> No, highmem really isn't nearly enough.
>
> Imagine you have (like I do) a system with 36 bits of IPA space.
> Create a VM with 8GB of RAM (which means the low-end of IPA space is
> already 9GB). Obviously, highmem=true here. With the current code, we
> will try to expose this PCI MMIO range, which falls way out of the IPA
> space (you need at least 40 bits of IPA to even cover it with the
> smallest configuration).
In that case the he High MMIO region is accounted in the vms->highest_gpa:

    for (i = VIRT_LOWMEMMAP_LAST; i < ARRAY_SIZE(extended_memmap); i++) {
        hwaddr size = extended_memmap[i].size;

        base = ROUND_UP(base, size);
        vms->memmap[i].base = base;
        vms->memmap[i].size = size;
        base += size;
    }
    vms->highest_gpa = base - 1;

and virt_kvm_type() should exit in that case at:
if (requested_pa_size > max_vm_pa_size) {
        error_report("-m and ,maxmem option values "
                     "require an IPA range (%d bits) larger than "
                     "the one supported by the host (%d bits)",
                     requested_pa_size, max_vm_pa_size);
        exit(1);
    }

?
>
> highmem really is a control that says 'things may live above 4GB'. It
> doesn't say *how far* above 4GB it can be placed. Which is what I am
> trying to address.

OK I will look at your v4 ;-)

Thanks

Eric
>
> Thanks,
>
> 	M.
>

