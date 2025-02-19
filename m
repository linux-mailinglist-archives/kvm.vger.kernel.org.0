Return-Path: <kvm+bounces-38589-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5CDEAA3C7CB
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 19:41:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B903E1650E7
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2025 18:41:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE577215042;
	Wed, 19 Feb 2025 18:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XUk6FGXH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578FD214800
	for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 18:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739990461; cv=none; b=HDx64Ja52fMJ48uGu+pkJfpXZViLcloSAEmYLdTnHOfy6OGq8rja6I53hn0gnMXlIdpZKTTHN/mZbp5nbyfPcT9CXwXlQo8cmAgY3/aXM5o60obpcQHPFOhF4fMXmPFkgL3PctLNe4e7rhpOoBpOsKUJErT4GEs+6y+Bbd66dvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739990461; c=relaxed/simple;
	bh=/OtqSjXbagUnsCid0/oHn9PhLNKMS6msEvvBfVR4XB4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NftR8LBT2xK4XxdkIdmnLAlzdWsia02h6pzoq6i2IC6v9iJ+ovgVdNj4tXfDVrcvb5mYQOp4Hr7WVLilM4UKkZ8DZX3oVYJkZfN60Ue+713Yp9g0IHrRxLM/UD9kD06jqOFzX57Z/uLbQfoa4ffI7oIR4VPz0lA8xwEKtNXHSNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XUk6FGXH; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-38f2b7ce319so84027f8f.2
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2025 10:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739990458; x=1740595258; darn=vger.kernel.org;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/OtqSjXbagUnsCid0/oHn9PhLNKMS6msEvvBfVR4XB4=;
        b=XUk6FGXHqoLCJCnzXmsMN1X4v/qrR9vSlNZY/ayvfIGL7GvHWdjL9fHeyR4c30/Xz1
         2Bzm+uiqkWr4ZOs2TUju92OMszUsN08KT/uhpOzxILWOgPJsh5S2Z1fjjwWk76qvGDTk
         ECXXEHezcLXepPanHanCC81vpNcefQRBhCUqnUoNDss7Ifh0lDO+brZ6dR5GTdjho87O
         anE2hImzg3B57TvaokaRz70Vi3VMX5V2ZuC1dL+csLgll9S4RnB3il2YENV2pgGJUZ6h
         hl2I9ffsWAKvzbw83cwpp0wFhDf6qR125imk8mxx1HsGYE/gmWZlDccukU3b8GOOEHG9
         aeGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739990458; x=1740595258;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/OtqSjXbagUnsCid0/oHn9PhLNKMS6msEvvBfVR4XB4=;
        b=eHm7NtgIwxuq03Q/+5sqryg2lQJi8Wj7jZNMnWDsA9u6u6T6x7TMND5yBHvFYsakT7
         h9dF4/szQz+0X5skFKFdbVTeFvS5/V1ynBnG0oi7slkNuLL/3T67FCQWw92Wgi/+COY9
         XIGWj2FH3ybpOAhVt4DT1p37Ns5zg+yy9wx926BcKins7pN6WbeL5EIjqWviwCyhVznh
         nEDlSq47kdr0p9azQdRS6cdpgR001lsLajIo1gdyveEXeQ6w1FvcyATNFMsTj1X2lgu3
         JS/4MIYbQfI+aABxSdZyitMEdIPbVCVM2EOERhNevziWNqg6fzVIm+lF8PDzb6u3CwIO
         mEBA==
X-Forwarded-Encrypted: i=1; AJvYcCW1xhoxiTizM7KstwncD+gcTOQ/Poytzys8leLg4FLqjMBe3zHPc9p8Sl3eoO3I+VszDrw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyrJrM7AyjIPrJyRDAPbV49Jc23x0mhn+WxVJRz1gSkg+xn9ImO
	bSPHG29/Dw5kkU3Q4cHCR3T6xfp9vpGFyy0gTQCxJzUYgvsWiVEg
X-Gm-Gg: ASbGncvHKpDjGVg9ofNkh6s7xWEJgnFC+lUZ/A5HIbw1Lwc85F0sbd+SP05vp1/YzzW
	qdD6PgdfWdwSxDaqTnk/RYQ6GHUEelrxWdGs4xs7iT1uuOhuiWFcNFJR+TVJlxsg5R3Cni4VieO
	Anooss/IWM2yxRFbmubj0LkruC8A3SzY8ZagE+Ve8JZ1uKMOrx7ubyihmQpw6qqMyH2/zYFwq3U
	vYjVNzmINvnvp+VV2v2+BZfPLNZfIeN0qpwon+0U8VukOjnsyiM9sa/bKso0WFt2XTqF0E/sWer
	R+QSsrpVKYeQKKf/SmrtQmbsgxGCBFep8gDzKIdB+Ny/K/5aOEZfPPaOF5Vlo/wbcOHL9v3T
X-Google-Smtp-Source: AGHT+IHNWff6bm6fcfE+5ecgPtRmmGb/q23mIiPvzoYQd4Fg1YiKPesnVQ/LkhSh+kZVSeG/Z0273g==
X-Received: by 2002:a05:6000:1bc1:b0:38f:31b6:4f30 with SMTP id ffacd0b85a97d-38f587ca52bmr4213709f8f.35.1739990458369;
        Wed, 19 Feb 2025 10:40:58 -0800 (PST)
Received: from ?IPv6:2001:b07:5d29:f42d:ee78:9ac0:bfb1:1189? ([2001:b07:5d29:f42d:ee78:9ac0:bfb1:1189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f258b4118sm19010299f8f.18.2025.02.19.10.40.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 10:40:58 -0800 (PST)
Message-ID: <4ec0652b387427cfadaef796ae9162921115bf43.camel@gmail.com>
Subject: Re: [PATCH v7 19/52] i386/tdx: Track mem_ptr for each firmware
 entry of TDVF
From: Francesco Lavra <francescolavra.fl@gmail.com>
To: Xiaoyao Li <xiaoyao.li@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	"Daniel P." =?ISO-8859-1?Q?Berrang=E9?=
	 <berrange@redhat.com>, Philippe =?ISO-8859-1?Q?Mathieu-Daud=E9?=
	 <philmd@linaro.org>, Igor Mammedov <imammedo@redhat.com>
Cc: Zhao Liu <zhao1.liu@intel.com>, "Michael S. Tsirkin" <mst@redhat.com>, 
 Eric Blake <eblake@redhat.com>, Markus Armbruster <armbru@redhat.com>,
 Peter Maydell <peter.maydell@linaro.org>, Marcelo Tosatti
 <mtosatti@redhat.com>, Huacai Chen <chenhuacai@kernel.org>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>,  qemu-devel@nongnu.org, kvm@vger.kernel.org
Date: Wed, 19 Feb 2025 19:40:56 +0100
In-Reply-To: <20250124132048.3229049-20-xiaoyao.li@intel.com>
References: <20250124132048.3229049-1-xiaoyao.li@intel.com>
	 <20250124132048.3229049-20-xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-2 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Fri, 2025-01-24 at 08:20 -0500, Xiaoyao Li wrote:
> diff --git a/target/i386/kvm/tdx.c b/target/i386/kvm/tdx.c
> index 73f90b0a2217..8564b3ae905d 100644
> --- a/target/i386/kvm/tdx.c
> +++ b/target/i386/kvm/tdx.c
> @@ -12,10 +12,14 @@
> =C2=A0#include "qemu/osdep.h"
> =C2=A0#include "qemu/error-report.h"
> =C2=A0#include "qemu/base64.h"
> +#include "qemu/mmap-alloc.h"
> =C2=A0#include "qapi/error.h"
> =C2=A0#include "qom/object_interfaces.h"
> =C2=A0#include "crypto/hash.h"
> +#include "system/system.h"
> =C2=A0
> +#include "hw/i386/x86.h"
> +#include "hw/i386/tdvf.h"
> =C2=A0#include "hw/i386/x86.h"

Duplicated include

