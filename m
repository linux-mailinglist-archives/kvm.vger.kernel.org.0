Return-Path: <kvm+bounces-50711-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 04DE1AE888B
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 17:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 599966819F5
	for <lists+kvm@lfdr.de>; Wed, 25 Jun 2025 15:45:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB69C29B23C;
	Wed, 25 Jun 2025 15:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C1qL2jOw"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB72628935E
	for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 15:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750866354; cv=none; b=i/DIo6Pe6+trb3gHfdQA9OiZu2HnWNZ87AL9vjm8i+VCatxV6muztb1I/ptgd7+34BGe4nWsVn4dd67sQElk5CDF/pUJkP//4Ql+qbeupSv1f5hY6VZVYoHTcqonWQwUsAr5++rSCRAnBFkOM3K7g4xT6ZQbUv6UNuAjxWNecAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750866354; c=relaxed/simple;
	bh=iX1ZMXUxHeJcXTTZIyi0inu9cpY5d1xowmokU1xy9iU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MRINIpzGaFdLd6sXg2IFrV1HfrZw6T1D7oxghrfw0JWHMUF2KLmzC97hpQjLddrpYtz9HxX/Ee/KLkirfYkC+Rzuu5DmpVHTZH6H/S4pCQPBXIDzFJxNycVhBA1KTKQlA0v5glp7SESFyaCci+ft2dkcGdPzdic3TOoc+X/uIdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C1qL2jOw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750866350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+lyKi4XBHGDSbK3UmgNeZlODsDYozuEN3Hh1wy9C8tQ=;
	b=C1qL2jOwMxI7+ws6Wp19PNZduMulJ6kIU4pQ3KFfOnUfvY3MOthTWT5F1ckW2onOq217cs
	K3FWBu2qW6WVIm1yfrxuhht5gn4HzLnC2Z1iWP60yShI9YWUl0ZE+dN6d4CL/InNrdc2Kq
	A1uKMkRCvRyGOHl3K8VXEy6jOJVY9vc=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-CLEl7eBTOjyzV5D9dZgNHQ-1; Wed, 25 Jun 2025 11:45:49 -0400
X-MC-Unique: CLEl7eBTOjyzV5D9dZgNHQ-1
X-Mimecast-MFC-AGG-ID: CLEl7eBTOjyzV5D9dZgNHQ_1750866348
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-451ac1b43c4so9599025e9.0
        for <kvm@vger.kernel.org>; Wed, 25 Jun 2025 08:45:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750866348; x=1751471148;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+lyKi4XBHGDSbK3UmgNeZlODsDYozuEN3Hh1wy9C8tQ=;
        b=BO4DjZhPJb9AMrZ6d628n7KaVLx2ZJ7dV9QmJsnN76ZDyVodQU2g7UkGFkhR/TR+gu
         RC4ebtWaWpXsX65BPQ7j1ottER0GmByHmTWkwr/vwfTO1lWgCejeGtgbNKxHX0pYrQn3
         ISorC1fkMRb8n7t8PHidm0AEypbnc014ZM/N4FnBeemyMVNdWJtWSB3cap50k/lpieC2
         rWho8/NevtT9GjtPmE9NE32/J7twkdULZF8WjUYFqvGkjbxF+D44DMmL5QvgdwFcg6FT
         1qkoMKpZME7oWWOxR/dxwvY2KsQReTwVPr+gbjfCqoozTz/690qJ6uPd2B1RHTDA1JJX
         cthQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCsYvDdY3W4oFJdqikwvALVhs1NTnz9fmVHkL20SaBYnd9/+mVNx5dfqJ+x7WdYa7wAo0=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz9b+LPQ2MobZWS87Zc3g2hJDOaKSHKBdGXTfurILj6Rh+PaIqq
	v/F1AFlfKunD0OTH84rVVlqDHDnphOw7ABeJV6G8KcFod9xlTnsS1OlDk4bASiZbxj4jRKQaSAq
	rFuW+2yJ4n5lmYDyZ0VVU9LevvvQVtBNJ1ntHAKiMYqg9zp9gYAfzBw==
X-Gm-Gg: ASbGnct9qOz96LcIyzHSrqnxWtN1wQNBHocYW+gUSCCzD3EGRpUm1dryQxmwyqxwHJ7
	4RSM1f2mvUxmVCrnQ9sw7a4tj1xf0Qd/0ymm6bep2vs8lM1QSQ1iVRRWHd2pJbpSKLHSU6X0to+
	gBtC212mASAM6EDOs4VvP6bHLtrVEAQqLPFWhCzaNWU4yDPYxMByvxNSU+AgkJ5JX9DPr2GMlPK
	ON3CFXZ1af9W/G5MLOZuG29DQpWoOcs9CFK5W/r0N+85z8Sy1JtV9WQvToA2bA7OXUjf3o9u8Bu
	/Yucx2uva3DB3bu+v32HAz+Qq5XHwcLAGyRIlTS6h9rcsYXPt0Q5Ytpf5uzvzSY=
X-Received: by 2002:a05:600c:4454:b0:453:483b:6272 with SMTP id 5b1f17b1804b1-45381ab98cfmr34611355e9.7.1750866348125;
        Wed, 25 Jun 2025 08:45:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGN5Gzyi7uxYalmfI3BJCHwIAgsjlRbRdEYZVNJVHAndtbM9f5MRafkfmlUO3+GroDLnVcjjA==
X-Received: by 2002:a05:600c:4454:b0:453:483b:6272 with SMTP id 5b1f17b1804b1-45381ab98cfmr34611015e9.7.1750866347681;
        Wed, 25 Jun 2025 08:45:47 -0700 (PDT)
Received: from [192.168.0.7] (ltea-047-064-115-198.pools.arcor-ip.net. [47.64.115.198])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-453823563fasm23296755e9.21.2025.06.25.08.45.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Jun 2025 08:45:46 -0700 (PDT)
Message-ID: <b5deb678-fcf8-494b-bc92-37ddbdfeaf20@redhat.com>
Date: Wed, 25 Jun 2025 17:45:45 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/12] linux-headers: replace FSF postal address with
 licenses URL
To: Sean Wei <me@sean.taipei>, qemu-devel@nongnu.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Cornelia Huck <cohuck@redhat.com>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "open list:Overall KVM CPUs" <kvm@vger.kernel.org>
References: <20250613.qemu.patch@sean.taipei>
 <20250613.qemu.patch.02@sean.taipei>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250613.qemu.patch.02@sean.taipei>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 13/06/2025 18.38, Sean Wei wrote:
> The GPLv2 boiler-plate in asm-arm/kvm.h and asm-powerpc/kvm.h still
> contained the obsolete "51 Franklin Street" postal address.
> 
> Replace it with the canonical GNU licenses URL recommended by the FSF:
> https://www.gnu.org/licenses/
> 
> Signed-off-by: Sean Wei <me@sean.taipei>
> ---
>   linux-headers/asm-arm/kvm.h     | 4 ++--
>   linux-headers/asm-powerpc/kvm.h | 4 ++--
>   2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/linux-headers/asm-arm/kvm.h b/linux-headers/asm-arm/kvm.h
> index 0db5644e27..a8bb1aa42a 100644
> --- a/linux-headers/asm-arm/kvm.h
> +++ b/linux-headers/asm-arm/kvm.h
> @@ -13,8 +13,8 @@
>    * GNU General Public License for more details.
>    *
>    * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + * along with this program; if not, see
> + * <https://www.gnu.org/licenses/>.
>    */
>   
>   #ifndef __ARM_KVM_H__
> diff --git a/linux-headers/asm-powerpc/kvm.h b/linux-headers/asm-powerpc/kvm.h
> index eaeda00178..83faa7fae3 100644
> --- a/linux-headers/asm-powerpc/kvm.h
> +++ b/linux-headers/asm-powerpc/kvm.h
> @@ -10,8 +10,8 @@
>    * GNU General Public License for more details.
>    *
>    * You should have received a copy of the GNU General Public License
> - * along with this program; if not, write to the Free Software
> - * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + * along with this program; if not, see
> + * <https://www.gnu.org/licenses/>.
>    *
>    * Copyright IBM Corp. 2007
>    *

This also has to be fixed in the Linux kernel first, otherwise the changes 
will be reverted when someone runs the scripts/update-linux-headers.sh 
script. Sorry, I should have mentioned that in the 
https://gitlab.com/qemu-project/qemu/-/issues/2974 ticket, but I missed it, 
sorry!

  Thomas


