Return-Path: <kvm+bounces-12314-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9CE08815C2
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 17:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83927281A84
	for <lists+kvm@lfdr.de>; Wed, 20 Mar 2024 16:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 508EB1C20;
	Wed, 20 Mar 2024 16:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Pj9Tm7Ye"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32D015A5
	for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 16:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710952736; cv=none; b=Q+iGoalu6SWYT0e57zA9SX5HLGB78V+xra2MpQNtf9I0j281Rx/8Qbx2gfEhUWPdUwyc7aaNYY6+r+NDylgvBpv6EyI4Peh41eGNIrJwHLI/AR6bu+WGudpliWQVcDjKsuT5yvrCk+ukyXWM1OPx5o7UhqByZlPlNeCdxgjUpfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710952736; c=relaxed/simple;
	bh=IB76lUs9IPAV243Xf3gz2nKBTSymIpnEUH+xLc8LLpQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EXDcbaJTrITuGn6a6lRmikwLbUospCfEdAIRJ3m29Ziq2a31pjLM3LYBE9LlFiruhr/OfLaw7LRqNIYFnucBobruwaEyBNmoNUkSmdwaC1PHrEezEdsyWUruQHU/72YOO6fXJ9tu+Yz+JDa+GGyJFwSOkeUMbgCsz3m4OAJDGxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Pj9Tm7Ye; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1710952733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=K5r5p+TdefoFVY2Sm9HFnen4qIuY7gJN6xyg80IowfU=;
	b=Pj9Tm7Yeze9+oGM3+JmUWyTXUkCxuxu/aUyL4BIVgymH73GKorcaRSq2ZdAue4lGMYuzfC
	l7gJ7h5Yh+6mU/5AzTgoeZGCM2lwCkhG4JdKuHx6QhF0YTIkVnHqRO0MzaG5vh5iUfjwi+
	CXcvdJr2+7PHaWkrxapOb4sxEsKnV9g=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-90-TIGXQ6vqNhS_DGk_P2YPKQ-1; Wed, 20 Mar 2024 12:38:52 -0400
X-MC-Unique: TIGXQ6vqNhS_DGk_P2YPKQ-1
Received: by mail-vs1-f69.google.com with SMTP id ada2fe7eead31-4767d683821so1220568137.1
        for <kvm@vger.kernel.org>; Wed, 20 Mar 2024 09:38:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710952730; x=1711557530;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K5r5p+TdefoFVY2Sm9HFnen4qIuY7gJN6xyg80IowfU=;
        b=AsX1qPMJCc5zLeT2KCjvKgJPixvmccyElOKJTDGvJhvhqK496X9Qzqiid2x6OrDwSK
         kAASMNOLb1ykb7Xdmu3FqOgVqNkkNDpAD4Fyf45AeKwtIFXsVOe5o4cJ1VbrGe5n3m8K
         n01/3FdslCdt9N7VcRp/P2qVAip6Ecs7He3hp1jJLT7zwPrpLEBPJGr6SWiIA9jKCnem
         /lZnYY96dRa1/QntrOpntW7aRVItltuOqKySmz+Kwpn73PpRJ/rOITliGVXIZ+huS+uQ
         RINX0gkEJE/SgHp4UuUJkEn2uSfBu2vhbgHvbt6xyEmPIFrffYjCujer+iSsQhc9fIQT
         9wug==
X-Gm-Message-State: AOJu0Yzd/qoDCefSBtXgVUQEq3sQyHHBAHvu/xGrJmN5Llx2WZTUQOnP
	cw9HJBmOP5sIkuAAEUXnZoqp80rf08XsVLTZx3eH5dwRze1cBjhduC9fNG6McQSggeRKUIP6NEV
	Tn/gLiao5NUVExYj5tOIjhS8Ka6exX0CMmmxW/PBg40cV324wSQ==
X-Received: by 2002:a67:f744:0:b0:475:fb4c:7945 with SMTP id w4-20020a67f744000000b00475fb4c7945mr17255618vso.26.1710952730751;
        Wed, 20 Mar 2024 09:38:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHjdSZzCVJ68iThyIsGzMXH+YUdcqituas/ZbaBs84fPj14wkD26kaOdp/88pPYCe+J59FWmg==
X-Received: by 2002:a67:f744:0:b0:475:fb4c:7945 with SMTP id w4-20020a67f744000000b00475fb4c7945mr17255600vso.26.1710952730493;
        Wed, 20 Mar 2024 09:38:50 -0700 (PDT)
Received: from [192.168.10.118] ([151.95.49.219])
        by smtp.googlemail.com with ESMTPSA id d24-20020ab07258000000b007dc1a45e05fsm1572801uap.39.2024.03.20.09.38.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Mar 2024 09:38:49 -0700 (PDT)
Message-ID: <08fc19f0-fa0a-40c5-b77f-90ea55c140a2@redhat.com>
Date: Wed, 20 Mar 2024 17:38:46 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/49] RAMBlock: Add support of KVM private guest memfd
Content-Language: en-US
To: Michael Roth <michael.roth@amd.com>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
 =?UTF-8?Q?Daniel_P_=2E_Berrang=C3=A9?= <berrange@redhat.com>,
 Markus Armbruster <armbru@redhat.com>, Pankaj Gupta <pankaj.gupta@amd.com>,
 Xiaoyao Li <xiaoyao.li@intel.com>,
 Isaku Yamahata <isaku.yamahata@linux.intel.com>,
 David Hildenbrand <david@redhat.com>
References: <20240320083945.991426-1-michael.roth@amd.com>
 <20240320083945.991426-7-michael.roth@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Autocrypt: addr=pbonzini@redhat.com; keydata=
 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
In-Reply-To: <20240320083945.991426-7-michael.roth@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 09:39, Michael Roth wrote:
> @@ -1842,6 +1842,17 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
>           }
>       }
>   
> +    if (kvm_enabled() && (new_block->flags & RAM_GUEST_MEMFD)) {
> +        assert(new_block->guest_memfd < 0);
> +
> +        new_block->guest_memfd = kvm_create_guest_memfd(new_block->max_length,
> +                                                        0, errp);
> +        if (new_block->guest_memfd < 0) {
> +            qemu_mutex_unlock_ramlist();
> +            return;
> +        }
> +    }
> +

This potentially leaks new_block->host.  This can be squashed into the patch:

diff --git a/system/physmem.c b/system/physmem.c
index 3a4a3f10d5a..0836aff190e 100644
--- a/system/physmem.c
+++ b/system/physmem.c
@@ -1810,6 +1810,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
      const bool shared = qemu_ram_is_shared(new_block);
      RAMBlock *block;
      RAMBlock *last_block = NULL;
+    bool free_on_error = false;
      ram_addr_t old_ram_size, new_ram_size;
      Error *err = NULL;
  
@@ -1839,6 +1841,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
                  return;
              }
              memory_try_enable_merging(new_block->host, new_block->max_length);
+            free_on_error = true;
          }
      }
  
@@ -1849,7 +1852,7 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
                                                          0, errp);
          if (new_block->guest_memfd < 0) {
              qemu_mutex_unlock_ramlist();
-            return;
+            goto out_free;
          }
      }
  
@@ -1901,6 +1904,13 @@ static void ram_block_add(RAMBlock *new_block, Error **errp)
          ram_block_notify_add(new_block->host, new_block->used_length,
                               new_block->max_length);
      }
+    return;
+
+out_free:
+    if (free_on_error) {
+        qemu_anon_ram_free(new_block->host, new_block->max_length);
+        new_block->host = NULL;
+    }
  }
  
  #ifdef CONFIG_POSIX


