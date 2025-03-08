Return-Path: <kvm+bounces-40481-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E36CAA57C79
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 18:45:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C882D7A406D
	for <lists+kvm@lfdr.de>; Sat,  8 Mar 2025 17:44:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0053B1DE4E7;
	Sat,  8 Mar 2025 17:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DTQ6rHAk"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F79382
	for <kvm@vger.kernel.org>; Sat,  8 Mar 2025 17:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741455928; cv=none; b=eTnY6fOh42F2Rxiy+VqW3UWa2VyQPi6A+jpWYB7hXIME11zir+4R0ktY/LN3/DE7XO0onwcEcsxhfiHt1iL7xurNkm/l63iNnlJjDaH5VmztHYzeblO/DNT6VDLaUJrO0wwHSEX2snqliRbT0GojLx1yOLMsq1XrKHzZ9v0NwXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741455928; c=relaxed/simple;
	bh=RgKU/ehckA87TRLCAW02FOV8vU0sWU+h5KPoL6KAzFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ary8COSO1tVZiuCQD5lpq3KWpLJGpD6/5uBKQzNyqDJdZ7uDdr/vg1WPxaHdyC22PNvb1Fd3dtLzhgbZVaaPJmM13AYUPRt1vGcoS3Vaw051CQ9p4bEhsh32ufx9+efHfkI2sedFEdmHTJSOg+AJpLSRxFx+7tx8H6D6qYVfZCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DTQ6rHAk; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741455925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=mjTdkrFZuWvdWTAh1zgNsoJqG2WEZml733leah2m8Gg=;
	b=DTQ6rHAkmpDgt5/E1TMhTkJFT11ORBouDiW+8kBYQaJh2y5aMhjPCVCCEYENBnriP/FWgf
	9tOBcvd36cdf5ttVQ29jWTFS5oltDrFuSBkc2eb9Bw1IYsyZ5zn3LUSOQAzDzIMedBnOCV
	m76ImN6WrucgkFU4ofoP90Zazzgb8io=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-12-Uk8TlmfKPom1xIzT37Wetw-1; Sat, 08 Mar 2025 12:45:23 -0500
X-MC-Unique: Uk8TlmfKPom1xIzT37Wetw-1
X-Mimecast-MFC-AGG-ID: Uk8TlmfKPom1xIzT37Wetw_1741455922
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-390ee05e2ceso1988710f8f.3
        for <kvm@vger.kernel.org>; Sat, 08 Mar 2025 09:45:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741455922; x=1742060722;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mjTdkrFZuWvdWTAh1zgNsoJqG2WEZml733leah2m8Gg=;
        b=kNYDReUXOKhzJKfSuLT+4++OS2X+I3+A7jBUwIsrysyyooeXkPxxk3Ly5+2W4RXfFE
         niJQ+qEJ0M7swGLpqy+SN6Tm6KmwHaTcJagejRq+Etmp8/CfOrJplOzhajSUg/Tnjok2
         2PC2m/s51CEPUwfp54GBlKbBIJN7a9RLOiMeMVmsKlMypXFselNDMO8jEYGXvQGrlh7Q
         190X0oQ19+d96bbyKw8k0uUuMOmgSjYXZLMhovpJU11yCVOpbhQfrV+RTuYG6aE6uMT1
         Ybeol5TJQfb1mDemdSIpcBb9pIaS17arTjQ3KW140ZNNU0Bcqf2tad/USxx7cl204HiW
         Ci5w==
X-Forwarded-Encrypted: i=1; AJvYcCWZ9mJgFAkP3ipQrhhx5yPAQsjpZHFAOXBPkV9fv91J8IhE866Bhs6bjJue9chwD1m+Abo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyxgcusTEluq5nqNn82HhxOKJq6X4Yy5nHqA0zZwCQk/ZqO4U2L
	UnRdfmusw4029jgpkNQJxU0TZ/ZAApjumXQQb3k/B6BV+2WykVZqa0F9dMgAwVR3yZ4M9Mul3c3
	M1J+BC4cs4ONhJ1m1Z0pmnsIS3ktCg+8/0L7pSN12vifndt0opA==
X-Gm-Gg: ASbGncsm1hnJFkfWar4ULha37OawDXfYqk5UiZMMyB3cXjH3LKX5I1ALsg/xggG0VW2
	d2Wr7Tst5AXYFyLjS/VKLIlB/0FUz766KCA2uU7ur3fpqCEbYG5reJ0p+XIyx4BKQRmHe6Qvdvc
	nPY6qNSzli4pAjb4/JVWW9RIxMhDnulXfgLXleXtN/fkIDOHnLl+YWIkg5SAxoVyIohttEYhP2d
	56V+5ELJ0fR6c+tMTO0AiUQDPXNPcIcdLJUBxTorZ8QwwS+GmMvivlWOfzDnHdzcpUb8MXVmzMe
	VNahyLSY/BXGcOCoJInMMkEZXTzB6RKeN3Cz0tXYcyhw7WN578C1ug==
X-Received: by 2002:a05:6000:402a:b0:38f:2efb:b829 with SMTP id ffacd0b85a97d-39132db8f39mr5943443f8f.50.1741455922450;
        Sat, 08 Mar 2025 09:45:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IE6Mffxb6wYLttfEY21IB4bHy2BmDyFTwXh1nzS54mVgWzfROsEuekoUiHLtDmv/iHFt75pzw==
X-Received: by 2002:a05:6000:402a:b0:38f:2efb:b829 with SMTP id ffacd0b85a97d-39132db8f39mr5943430f8f.50.1741455922126;
        Sat, 08 Mar 2025 09:45:22 -0800 (PST)
Received: from ?IPV6:2a01:e0a:280:24f0:9db0:474c:ff43:9f5c? ([2a01:e0a:280:24f0:9db0:474c:ff43:9f5c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfb7ae4sm9150968f8f.5.2025.03.08.09.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Mar 2025 09:45:20 -0800 (PST)
Message-ID: <910fe741-4ce0-482b-840c-132bf693930b@redhat.com>
Date: Sat, 8 Mar 2025 18:45:19 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/14] hw/vfio: Compile more objects once
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: Alex Williamson <alex.williamson@redhat.com>,
 Igor Mammedov <imammedo@redhat.com>, qemu-ppc@nongnu.org,
 Thomas Huth <thuth@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 Tony Krowiak <akrowiak@linux.ibm.com>, Ilya Leoshkevich <iii@linux.ibm.com>,
 kvm@vger.kernel.org, Yi Liu <yi.l.liu@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 Zhenzhong Duan <zhenzhong.duan@intel.com>,
 Matthew Rosato <mjrosato@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>,
 Peter Xu <peterx@redhat.com>, Pierrick Bouvier
 <pierrick.bouvier@linaro.org>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Eric Auger <eric.auger@redhat.com>, qemu-s390x@nongnu.org,
 Jason Herne <jjherne@linux.ibm.com>, David Hildenbrand <david@redhat.com>,
 =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>, Halil Pasic <pasic@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>
References: <20250307180337.14811-1-philmd@linaro.org>
 <20250307180337.14811-5-philmd@linaro.org>
Content-Language: en-US, fr
From: =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@redhat.com>
Autocrypt: addr=clg@redhat.com; keydata=
 xsFNBFu8o3UBEADP+oJVJaWm5vzZa/iLgpBAuzxSmNYhURZH+guITvSySk30YWfLYGBWQgeo
 8NzNXBY3cH7JX3/a0jzmhDc0U61qFxVgrPqs1PQOjp7yRSFuDAnjtRqNvWkvlnRWLFq4+U5t
 yzYe4SFMjFb6Oc0xkQmaK2flmiJNnnxPttYwKBPd98WfXMmjwAv7QfwW+OL3VlTPADgzkcqj
 53bfZ4VblAQrq6Ctbtu7JuUGAxSIL3XqeQlAwwLTfFGrmpY7MroE7n9Rl+hy/kuIrb/TO8n0
 ZxYXvvhT7OmRKvbYuc5Jze6o7op/bJHlufY+AquYQ4dPxjPPVUT/DLiUYJ3oVBWFYNbzfOrV
 RxEwNuRbycttMiZWxgflsQoHF06q/2l4ttS3zsV4TDZudMq0TbCH/uJFPFsbHUN91qwwaN/+
 gy1j7o6aWMz+Ib3O9dK2M/j/O/Ube95mdCqN4N/uSnDlca3YDEWrV9jO1mUS/ndOkjxa34ia
 70FjwiSQAsyIwqbRO3CGmiOJqDa9qNvd2TJgAaS2WCw/TlBALjVQ7AyoPEoBPj31K74Wc4GS
 Rm+FSch32ei61yFu6ACdZ12i5Edt+To+hkElzjt6db/UgRUeKfzlMB7PodK7o8NBD8outJGS
 tsL2GRX24QvvBuusJdMiLGpNz3uqyqwzC5w0Fd34E6G94806fwARAQABzSJDw6lkcmljIExl
 IEdvYXRlciA8Y2xnQHJlZGhhdC5jb20+wsGRBBMBCAA7FiEEoPZlSPBIlev+awtgUaNDx8/7
 7KEFAmTLlVECGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQUaNDx8/77KG0eg//
 S0zIzTcxkrwJ/9XgdcvVTnXLVF9V4/tZPfB7sCp8rpDCEseU6O0TkOVFoGWM39sEMiQBSvyY
 lHrP7p7E/JYQNNLh441MfaX8RJ5Ul3btluLapm8oHp/vbHKV2IhLcpNCfAqaQKdfk8yazYhh
 EdxTBlzxPcu+78uE5fF4wusmtutK0JG0sAgq0mHFZX7qKG6LIbdLdaQalZ8CCFMKUhLptW71
 xe+aNrn7hScBoOj2kTDRgf9CE7svmjGToJzUxgeh9mIkxAxTu7XU+8lmL28j2L5uNuDOq9vl
 hM30OT+pfHmyPLtLK8+GXfFDxjea5hZLF+2yolE/ATQFt9AmOmXC+YayrcO2ZvdnKExZS1o8
 VUKpZgRnkwMUUReaF/mTauRQGLuS4lDcI4DrARPyLGNbvYlpmJWnGRWCDguQ/LBPpbG7djoy
 k3NlvoeA757c4DgCzggViqLm0Bae320qEc6z9o0X0ePqSU2f7vcuWN49Uhox5kM5L86DzjEQ
 RHXndoJkeL8LmHx8DM+kx4aZt0zVfCHwmKTkSTQoAQakLpLte7tWXIio9ZKhUGPv/eHxXEoS
 0rOOAZ6np1U/xNR82QbF9qr9TrTVI3GtVe7Vxmff+qoSAxJiZQCo5kt0YlWwti2fFI4xvkOi
 V7lyhOA3+/3oRKpZYQ86Frlo61HU3r6d9wzOwU0EW7yjdQEQALyDNNMw/08/fsyWEWjfqVhW
 pOOrX2h+z4q0lOHkjxi/FRIRLfXeZjFfNQNLSoL8j1y2rQOs1j1g+NV3K5hrZYYcMs0xhmrZ
 KXAHjjDx7FW3sG3jcGjFW5Xk4olTrZwFsZVUcP8XZlArLmkAX3UyrrXEWPSBJCXxDIW1hzwp
 bV/nVbo/K9XBptT/wPd+RPiOTIIRptjypGY+S23HYBDND3mtfTz/uY0Jytaio9GETj+fFis6
 TxFjjbZNUxKpwftu/4RimZ7qL+uM1rG1lLWc9SPtFxRQ8uLvLOUFB1AqHixBcx7LIXSKZEFU
 CSLB2AE4wXQkJbApye48qnZ09zc929df5gU6hjgqV9Gk1rIfHxvTsYltA1jWalySEScmr0iS
 YBZjw8Nbd7SxeomAxzBv2l1Fk8fPzR7M616dtb3Z3HLjyvwAwxtfGD7VnvINPbzyibbe9c6g
 LxYCr23c2Ry0UfFXh6UKD83d5ybqnXrEJ5n/t1+TLGCYGzF2erVYGkQrReJe8Mld3iGVldB7
 JhuAU1+d88NS3aBpNF6TbGXqlXGF6Yua6n1cOY2Yb4lO/mDKgjXd3aviqlwVlodC8AwI0Sdu
 jWryzL5/AGEU2sIDQCHuv1QgzmKwhE58d475KdVX/3Vt5I9kTXpvEpfW18TjlFkdHGESM/Jx
 IqVsqvhAJkalABEBAAHCwV8EGAECAAkFAlu8o3UCGwwACgkQUaNDx8/77KEhwg//WqVopd5k
 8hQb9VVdk6RQOCTfo6wHhEqgjbXQGlaxKHoXywEQBi8eULbeMQf5l4+tHJWBxswQ93IHBQjK
 yKyNr4FXseUI5O20XVNYDJZUrhA4yn0e/Af0IX25d94HXQ5sMTWr1qlSK6Zu79lbH3R57w9j
 hQm9emQEp785ui3A5U2Lqp6nWYWXz0eUZ0Tad2zC71Gg9VazU9MXyWn749s0nXbVLcLS0yop
 s302Gf3ZmtgfXTX/W+M25hiVRRKCH88yr6it+OMJBUndQVAA/fE9hYom6t/zqA248j0QAV/p
 LHH3hSirE1mv+7jpQnhMvatrwUpeXrOiEw1nHzWCqOJUZ4SY+HmGFW0YirWV2mYKoaGO2YBU
 wYF7O9TI3GEEgRMBIRT98fHa0NPwtlTktVISl73LpgVscdW8yg9Gc82oe8FzU1uHjU8b10lU
 XOMHpqDDEV9//r4ZhkKZ9C4O+YZcTFu+mvAY3GlqivBNkmYsHYSlFsbxc37E1HpTEaSWsGfA
 HQoPn9qrDJgsgcbBVc1gkUT6hnxShKPp4PlsZVMNjvPAnr5TEBgHkk54HQRhhwcYv1T2QumQ
 izDiU6iOrUzBThaMhZO3i927SG2DwWDVzZltKrCMD1aMPvb3NU8FOYRhNmIFR3fcalYr+9gD
 uVKe8BVz4atMOoktmt0GWTOC8P4=
In-Reply-To: <20250307180337.14811-5-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/7/25 19:03, Philippe Mathieu-Daudé wrote:
> These files depend on the VFIO symbol in their Kconfig
> definition. They don't rely on target specific definitions,
> move them to system_ss[] to build them once.
> 
> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>


Reviewed-by: Cédric Le Goater <clg@redhat.com>

Thanks,

C.


> ---
>   hw/vfio/meson.build | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/hw/vfio/meson.build b/hw/vfio/meson.build
> index 8e376cfcbf8..2972c6ff8de 100644
> --- a/hw/vfio/meson.build
> +++ b/hw/vfio/meson.build
> @@ -14,13 +14,13 @@ vfio_ss.add(when: 'CONFIG_VFIO_PCI', if_true: files(
>   ))
>   vfio_ss.add(when: 'CONFIG_VFIO_CCW', if_true: files('ccw.c'))
>   vfio_ss.add(when: 'CONFIG_VFIO_PLATFORM', if_true: files('platform.c'))
> -vfio_ss.add(when: 'CONFIG_VFIO_XGMAC', if_true: files('calxeda-xgmac.c'))
> -vfio_ss.add(when: 'CONFIG_VFIO_AMD_XGBE', if_true: files('amd-xgbe.c'))
>   vfio_ss.add(when: 'CONFIG_VFIO_AP', if_true: files('ap.c'))
> -vfio_ss.add(when: 'CONFIG_VFIO_IGD', if_true: files('igd.c'))
>   
>   specific_ss.add_all(when: 'CONFIG_VFIO', if_true: vfio_ss)
>   
> +system_ss.add(when: 'CONFIG_VFIO_XGMAC', if_true: files('calxeda-xgmac.c'))
> +system_ss.add(when: 'CONFIG_VFIO_AMD_XGBE', if_true: files('amd-xgbe.c'))
> +system_ss.add(when: 'CONFIG_VFIO_IGD', if_true: files('igd.c'))
>   system_ss.add(when: 'CONFIG_VFIO', if_true: files(
>     'helpers.c',
>     'container-base.c',


