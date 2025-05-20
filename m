Return-Path: <kvm+bounces-47069-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DBB62ABCEB5
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 07:43:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD083189F351
	for <lists+kvm@lfdr.de>; Tue, 20 May 2025 05:43:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADFFE25A2CF;
	Tue, 20 May 2025 05:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E1AaoMDB"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADAA255250
	for <kvm@vger.kernel.org>; Tue, 20 May 2025 05:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747719790; cv=none; b=JQL/Vvd5uuAqq6Da+yOKeptB77BKLDeoxc6qcO2ezQiVNtgIdYh27jpXH4FY2VfC46iQaSVuuXiwOOvGrMd/IyGoeJmI6borRMokrtgsgPUTq5V9arZ1kD5aYYKWOlgdBRYBnNFuKhfG0RqXq16hVYROFnan6SpbRLHrV+YVuvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747719790; c=relaxed/simple;
	bh=wGLA9UW3i8e2fUmOovywO53VpSW0/b5aC1FAzfOEWiE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a2eR9NEqL6hJBQ7/wzdRCFRcgotHMHx0cokqrpP4k8KTmxV60PrI/KfzoGh6CFH+sZrCLo+hYK0jAn0UHVQ7CpQTOMH3CMu+sUN/H8jkyC5EU8RKcnP/HIVRyPtXlcpXgLDDblh9egxLg86pVZB/dWAA7zTYqFKOQEznh3YPnmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E1AaoMDB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747719788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IXgKREbXw8JOX7wRebCRg043QolDwSg2zAUdVPK1KQ0=;
	b=E1AaoMDBj4NkgMSVfdSAAz8GPhLeQKcXFv5Ay/Icg4TC6gqHa8+DzybVu+K4Gio23SMCiU
	At3sTXrvZeQknu6OBFh5hZ5GC3ZF9hCPAoKD9KIi5zRvanPZ5zkt9+yiTiWfHk/pca/NXJ
	NM7HkrKCD7oMRfYxuL4ieIFRHH52aa0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-685-4N13llBKMuaWbDz9g2ed7w-1; Tue, 20 May 2025 01:43:06 -0400
X-MC-Unique: 4N13llBKMuaWbDz9g2ed7w-1
X-Mimecast-MFC-AGG-ID: 4N13llBKMuaWbDz9g2ed7w_1747719785
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-43efa869b19so42289615e9.2
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 22:43:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747719785; x=1748324585;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IXgKREbXw8JOX7wRebCRg043QolDwSg2zAUdVPK1KQ0=;
        b=FSpnjNr0iDsJic5p8wzT74XbI1NgXoK4f2KhFBrzWTetEXxkx1DnBFJo2zZYrJO2TK
         bsuNqAY71WEsLa28rNfLHhYRnzzVriK1BnWc8G8tK+6l90AIZUIhsfmNQtBTiC6giSr9
         enMVr7d90t25uidtkWF7qKKaZGf6RiRHrmfwMpuKmyfVtA3wUaTP96OLfTKX5povPxzY
         IKNajApEVIxXeTmbk995VE6t+UoB6kO7PNxW3HwNJALigTz9owkjHfASIgZaY/dXS8iX
         IfY4fDTCMuwIsCgqJdjg8E8o/Pbf3ULgFg9wU9DHUSC5KXHZtMCPdYzdUCApqQFpRp4/
         SdOg==
X-Forwarded-Encrypted: i=1; AJvYcCVw+md5WFtnfFsgNpRQFluAe5AbVVLg/DqBmsOy6W9yeVMbLh4iVm4BS8SSpIPNZthGEos=@vger.kernel.org
X-Gm-Message-State: AOJu0YxoFXQod62ADd7Fv5nCuV1pBI9/2aSCUcWmmvWejPagaCBY+Z/m
	DfVXY+Ko5tkLP0EJVl0Q/oJR+DJJIbRcEFD/eCArsQyL/FzO7+bqKIhdSvJ2ewav3yiyWFnGwfW
	lF6sIS3iurbgdBSFq1PnIA9iwBEz8rn7PfybNecuWrQ2cH9gkf2hlxQ==
X-Gm-Gg: ASbGnct8cfOQZBFctaPzBjMY6CNtWVo/6O5zImvxKp6CM1OX8bxeDuaoBFTtuobx8vX
	PeI7F6JMT/dWd1J5jUnPhbS39CnD4MFRuDMGfYaU3EAiJ/OWD2Fl1eszA+0QGU4bk/lxhCjiFNI
	U4NRMJYnYT87X43K76X2yBlzlnC5l5wEIKbXbaYcN2Vzfxbdg5Z4Ofz2SwSYIiAxli0g/7Gk/+M
	XYjBK4C3l1jxBBrXDDHS8m/Ggmt3hVHUClQV4yHNfuoc+x+0Ct7sJe9hizk83tP6GF3gxikeloX
	SD5R3M5S6pZjVEuBwvHnuBkDSE9xhwEbX/JDLW3y4YM=
X-Received: by 2002:a05:600c:548e:b0:442:cd03:3e2 with SMTP id 5b1f17b1804b1-442fefd77a2mr146509265e9.2.1747719784965;
        Mon, 19 May 2025 22:43:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHd8GGWSj0p7IGH/FLOhkyp6Q8E4hyCeidUKsb74iDDbO1SfEAhR2sP0lZfWY9LlxVamb9kDQ==
X-Received: by 2002:a05:600c:548e:b0:442:cd03:3e2 with SMTP id 5b1f17b1804b1-442fefd77a2mr146509055e9.2.1747719784641;
        Mon, 19 May 2025 22:43:04 -0700 (PDT)
Received: from [192.168.0.7] (ip-109-42-49-201.web.vodafone.de. [109.42.49.201])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-447f1825193sm16679705e9.5.2025.05.19.22.43.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 May 2025 22:43:04 -0700 (PDT)
Message-ID: <afdc34e0-2dbe-4c5c-ac59-61530c45827d@redhat.com>
Date: Tue, 20 May 2025 07:43:02 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] KVM: s390: Specify kvm->arch.sca as esca_block
To: Christoph Schlameuss <schlameuss@linux.ibm.com>, kvm@vger.kernel.org
Cc: linux-s390@vger.kernel.org,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 David Hildenbrand <david@redhat.com>, Heiko Carstens <hca@linux.ibm.com>,
 Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev
 <agordeev@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>
References: <20250519-rm-bsca-v2-0-e3ea53dd0394@linux.ibm.com>
 <20250519-rm-bsca-v2-3-e3ea53dd0394@linux.ibm.com>
From: Thomas Huth <thuth@redhat.com>
Content-Language: en-US
Autocrypt: addr=thuth@redhat.com; keydata=
 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
In-Reply-To: <20250519-rm-bsca-v2-3-e3ea53dd0394@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/05/2025 13.36, Christoph Schlameuss wrote:
> We are no longer referencing a bsca_block in kvm->arch.sca. This will
> always be esca_block instead.
> By specifying the type of the sca as esca_block we can simplify access
> to the sca and get rid of some helpers while making the code clearer.
> 
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>   arch/s390/include/asm/kvm_host.h |  4 ++--
>   arch/s390/kvm/gaccess.c          | 10 +++++-----
>   arch/s390/kvm/kvm-s390.c         |  4 ++--
>   arch/s390/kvm/kvm-s390.h         |  7 -------
>   4 files changed, 9 insertions(+), 16 deletions(-)

Reviewed-by: Thomas Huth <thuth@redhat.com>


