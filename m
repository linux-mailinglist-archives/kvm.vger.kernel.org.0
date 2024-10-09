Return-Path: <kvm+bounces-28352-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0BC559975CF
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 21:42:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 950331C20FAB
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2024 19:42:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B6CC1E1C37;
	Wed,  9 Oct 2024 19:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="haTjw/NP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8CC1D356C;
	Wed,  9 Oct 2024 19:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728502895; cv=none; b=g1cC/aaL6EWSSH0Hag/8kR3uWC0lD61aWlT0m9Bs5EQuepG8JzgAntotFhOSskSW6QFYHt4e3UfxGNsok/klRqfbJZaMSnlZY8DFA099KAr9unM+4mBUITyVflL0O5JqFvKr8G3nBDbP5BhLFSE+fIm1FL02JSLhyKBzzJyWt1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728502895; c=relaxed/simple;
	bh=PDYidJaYfrjomUChvobIVbDDlDk1zVlAhYjbjjNl6kk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o+H6CCfb8S18xrvBoRqcrxuvK2RRal1DHcSnX2ZBkqtDbClthcm0cRGwortuoHHDu2cK1bhUCvdxzZRQqAXZKR40/e9WddzRxpcwGHlg4TlAXJO62R7Wswi5m0J0MtwmQqqcZd5aTdSD/EblOfl1EO6oF392m2GoH/6bKpoBKxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=haTjw/NP; arc=none smtp.client-ip=209.85.167.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f45.google.com with SMTP id 2adb3069b0e04-5398e4ae9efso144254e87.1;
        Wed, 09 Oct 2024 12:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728502891; x=1729107691; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Io1G2uneGwHsYKAwtaIvvynFX0xlOmokHD97rmisdy0=;
        b=haTjw/NP+LFmeIQsSVNPf46SPLroR5wQ6AWCHPRSbBBpgw+F6LbzczPdcsxcj+Ntjb
         Nz53fEVzXDtDgQNHs4YvCQFq3scwom4q7Jfy/LNzPIlpg3NjS37nVLmv76Yp9FkUm/kg
         73M4DFwUZ2524KA7afsKQ6mC5Pd0PSaXtdRuveZK6UuySuZr2OvgF0+hDhkQ8SZzxkAG
         g6xqFbldrYLghmZ79erydEMRhTRtzoGlntkYwY4GZhkHaa1ndHkSN+4U3G30rSQtJ011
         DQ7bN805MPsPBhc76d1uB6IcsFmR1ph0njamTa6rC3IvoAUaAbLnGFbA7vNfoh2rb1aE
         8uMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728502891; x=1729107691;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Io1G2uneGwHsYKAwtaIvvynFX0xlOmokHD97rmisdy0=;
        b=TAHtC2oKWz/rC+oStk+Qrp/2m4qlyakCppJiS7x7wfGdcouh/eWmtns7uDUZj9Qw27
         cBKExlIULxsPuMzdsRD6IxIppMFX5qOJTKaws07idfRt5yp4RYHKO6CqArLCTgat2aGe
         1qICug8nF/H5/hkFTqwsKABKFTx2NUKj1+1bsDyU8y5T14uFzJKpDi2M79m46Gw0H9H0
         Vb7NKBdFQxV+b/ABO9c17eksRs/f0AdxzCidUXTca2kdv7rQdLxoXUjZfajnC/+aquOx
         lEf7h7VRvKUsrgyF8JMJZYR3hlBjvy1ZdG+mhrDaUiTnraDa9VRGX3hV7zbgaugt441Y
         6Pzg==
X-Forwarded-Encrypted: i=1; AJvYcCU+FoGUdopiBLaS396PRGQ1dcvifUv6/uOOjMI30S6hw3fkdIs7nB4JZ/qVJ95DMA1o5YQ=@vger.kernel.org, AJvYcCU22lMiFkBD47zTH1OVp42UllylRYTA8BaPK+5oeWsurulvQ+FZepWEvOQsJjjjFcXyOvhqkJgYunpWqOqI@vger.kernel.org, AJvYcCUQIOAiUh1+OhuV1XKs2WYqtdbhRK6gBiThEMqZ7QXlEf0FPi19sSH5QC0X63R6E0rKwjWqAykhCnB7A8c=@vger.kernel.org, AJvYcCUpn7+BKorWkP5TURiNPAFZkDACudsaiEgtA0rBqo3UPCz9+GDst1+fYYC71HJNqssh8sBzMKqIB4VtRvk=@vger.kernel.org, AJvYcCVHZSJTCpiYlUTG4ZzaCDn2rN5OfROlhYPZb3RzvEgCgNtQG60k2FcCfxV8ovfUKFZ5t7cL/mD0Xeh5@vger.kernel.org, AJvYcCVKQT4GGqBKq28G8wsXdWfAOZsHyzXXW7f8ubmcG9ZYwEWZ5VFX4ZLSEqjoICk2kNrlQELg9zcQ@vger.kernel.org, AJvYcCWm/ZJt1tfbyTgNklluDJ+yVCuB/1Lp6Qg+ebxjMwl2gQNVL7YiS26V+QQSIEG+uDA8Wh6WaoGSHlMAxTS69Jg=@vger.kernel.org, AJvYcCX7HocRTfGz+82QIOjFXYcnVjkZeWdZ4mo51gwqzInVN5VgXiiFeJfEsaqMh7j/xLAZWi1ZTrhccfqz@vger.kernel.org
X-Gm-Message-State: AOJu0Ywufx1+08hjwgh9xWcbKb/6OFM0cKZ9CbuFaDBBBwAsM56qqrra
	zESJ3Bw/q7PzGQAIUJ+CZ/6u+0zoLRHL+9U3B/k8CRaRppt660RY
X-Google-Smtp-Source: AGHT+IEJ7Hh7KYSEFQ7TnvOgBW+KHHTbn0YpY2aq9eVXupaQTxUm7Wi9eOrRO7yFgrSR7VO5SquDug==
X-Received: by 2002:a05:6512:224b:b0:539:921a:44af with SMTP id 2adb3069b0e04-539c4967bbemr2532382e87.48.1728502891046;
        Wed, 09 Oct 2024 12:41:31 -0700 (PDT)
Received: from [192.168.2.105] (p54a0712c.dip0.t-ipconnect.de. [84.160.113.44])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-430ccf5f3adsm28720915e9.22.2024.10.09.12.41.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2024 12:41:30 -0700 (PDT)
Message-ID: <411f3c94-58b5-471e-bc58-e23d89d2078f@gmail.com>
Date: Wed, 9 Oct 2024 21:41:25 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 10/13] staging: rts5280: Use always-managed version of
 pci_intx()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Philipp Stanner <pstanner@redhat.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
 Sergey Shtylyov <s.shtylyov@omp.ru>,
 Basavaraj Natikar <basavaraj.natikar@amd.com>, Jiri Kosina
 <jikos@kernel.org>, Benjamin Tissoires <bentiss@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Alex Dubov <oakad@yahoo.com>,
 Sudarsana Kalluru <skalluru@marvell.com>, Manish Chopra
 <manishc@marvell.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Rasesh Mody <rmody@marvell.com>,
 GR-Linux-NIC-Dev@marvell.com, Igor Mitsyanko <imitsyanko@quantenna.com>,
 Sergey Matyukevich <geomatsi@gmail.com>, Kalle Valo <kvalo@kernel.org>,
 Sanjay R Mehta <sanju.mehta@amd.com>,
 Shyam Sundar S K <Shyam-sundar.S-k@amd.com>, Jon Mason <jdmason@kudzu.us>,
 Dave Jiang <dave.jiang@intel.com>, Allen Hubbe <allenbh@gmail.com>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Alex Williamson <alex.williamson@redhat.com>, Juergen Gross
 <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
 Mario Limonciello <mario.limonciello@amd.com>, Chen Ni <nichen@iscas.ac.cn>,
 Ricky Wu <ricky_wu@realtek.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Breno Leitao <leitao@debian.org>, Kevin Tian <kevin.tian@intel.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 =?UTF-8?Q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Mostafa Saleh <smostafa@google.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Hannes Reinecke <hare@suse.de>, John Garry <john.g.garry@oracle.com>,
 Soumya Negi <soumya.negi97@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 Yi Liu <yi.l.liu@intel.com>, "Dr. David Alan Gilbert" <linux@treblig.org>,
 Christian Brauner <brauner@kernel.org>, Ankit Agrawal <ankita@nvidia.com>,
 Reinette Chatre <reinette.chatre@intel.com>,
 Eric Auger <eric.auger@redhat.com>, Ye Bin <yebin10@huawei.com>,
 =?UTF-8?Q?Marek_Marczykowski-G=C3=B3recki?=
 <marmarek@invisiblethingslab.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Kai Vehmanen <kai.vehmanen@linux.intel.com>,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
 Rui Salvaterra <rsalvaterra@gmail.com>, Marc Zyngier <maz@kernel.org>,
 linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-input@vger.kernel.org, netdev@vger.kernel.org,
 linux-wireless@vger.kernel.org, ntb@lists.linux.dev,
 linux-pci@vger.kernel.org, linux-staging@lists.linux.dev,
 kvm@vger.kernel.org, xen-devel@lists.xenproject.org,
 linux-sound@vger.kernel.org
References: <20241009083519.10088-1-pstanner@redhat.com>
 <20241009083519.10088-11-pstanner@redhat.com>
 <2024100936-brunette-flannels-0d82@gregkh>
Content-Language: en-US
From: Philipp Hortmann <philipp.g.hortmann@gmail.com>
In-Reply-To: <2024100936-brunette-flannels-0d82@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/24 11:38, Greg Kroah-Hartman wrote:
> On Wed, Oct 09, 2024 at 10:35:16AM +0200, Philipp Stanner wrote:
>> pci_intx() is a hybrid function which can sometimes be managed through
>> devres. To remove this hybrid nature from pci_intx(), it is necessary to
>> port users to either an always-managed or a never-managed version.
>>
>> rts5208 enables its PCI-Device with pcim_enable_device(). Thus, it needs the
>> always-managed version.
>>
>> Replace pci_intx() with pcim_intx().
>>
>> Signed-off-by: Philipp Stanner <pstanner@redhat.com>
>> ---
>>   drivers/staging/rts5208/rtsx.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

Hi Philipp,

this driver (rts5208) will be removed soon - patch is send in.

Discussion about removal:
https://lore.kernel.org/linux-staging/2024100943-shank-washed-a765@gregkh/T/#t

Thanks for your support.

Bye Philipp


