Return-Path: <kvm+bounces-20536-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9676F917CC8
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 11:44:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4F857284AAD
	for <lists+kvm@lfdr.de>; Wed, 26 Jun 2024 09:44:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A3E416CD11;
	Wed, 26 Jun 2024 09:44:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RIFnRNiy"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AFDF33DD
	for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 09:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719395063; cv=none; b=ZjJ3XMU6zUELK8TlPZ8slaIQajiqHAU9ImjdPxiQG7qQY4YCg53yT/UXzZ3NMXsJjL3a9E17/qdhGge35IBfze6HDLPhnAart3HAUsKtPybcT35x6g2z0n2VktDZpFTjK9YCRUVTbpFZaI+5qMW3SHJKUWePLlw63u1768AFUt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719395063; c=relaxed/simple;
	bh=itDfSLjeq6SMUC2165Ju8LlKm495d6Rzv81PFmvoEis=;
	h=From:Message-ID:Date:MIME-Version:Subject:To:Content-Type; b=EnSF4fvVUrB6BM+1Ww+Jk+533xH0XZnTLWEV/hOpoDHCK0zYr9LgnZnQAT7QzB2pTCzI4TXB4zzxlyhNY5D578zVigg41sPUA8pHVjrxPTenlbrCxifutxWtSa/fb4U/P/gIkuW2nrpaV6ZUl8k/azruR3VAdMHbUWiBEdDIwPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RIFnRNiy; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1fa07e4f44eso35881785ad.2
        for <kvm@vger.kernel.org>; Wed, 26 Jun 2024 02:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719395061; x=1719999861; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:to:subject:user-agent
         :mime-version:date:message-id:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZbzsMvHFqVEef8goKnUx6Au2p32aFS0Ys4pF0Gk7B8=;
        b=RIFnRNiyy5AlatA+Y+ZXHmfwirKzzXJIkf63FZoHlrptl5sOggzVHJz3+krxcVWjIU
         6RV0rFW3/P/I+kgnP8re6SmQtKxq/U4J1yvz9a95tpSt/HidrjSCzQ18PY6fG0ceej0Z
         oZ7Brim7TVctOnlBK6B3LlGTjgypO1VMZZq3xB68JFeWKPAoBq+kJ+05HlMrLB6bPjwD
         ZdShdUIN750TAHia4I0iSr6kJfUR5Nw79ZCCtksE+kpxiBQLONrs5rxBhSp/EfvRAE0O
         ZF9XF2RaHjFkR1UhvOXJ+cL5anIe8OWkg19swDo5Cz6Pf9qNNo+V2XNHfEedIAa9FcAl
         HAbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719395061; x=1719999861;
        h=content-transfer-encoding:content-language:to:subject:user-agent
         :mime-version:date:message-id:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wZbzsMvHFqVEef8goKnUx6Au2p32aFS0Ys4pF0Gk7B8=;
        b=T3d7eoaE2wBMTdW1SVtgUjPl4559XZmQ1m++drWcoe9asgrLszixFFhUS2BEtWRhX2
         njYeJ9nT3venhwtPQpqJoRpEOLC0T0094TLx7sZn/mLzHf2lQiSrqBEmSStWFVSExkSn
         kh09xbl39flzAcSrn2bfVLFt8OrwVlaz6WLTFSPrq07TAzGbQxxfmURnOsnjBhTnqEPu
         aGxzqUWJ3pGz9ftQ5Vbkcj91+ivuxe3dkxqoTuJj5W31gNCi5S3RR0eN7QRMplaJA4Lv
         lP0/1Nx8qwlQ8z8LMzTtne4TWIpSjIQrkWT/KU5tj2gWOiWN8Vr8/gcZXaamwpH04IPT
         +zqA==
X-Gm-Message-State: AOJu0YybyUIi/xF8UJaNwe10nbdrd07MLNRryYXgOJMSH/kvrSmRHboP
	bdxFgz/z0IbJ+ttk74e+MHcqbygHV/YRH8HHcsRYMbTcTVPlVi2QzyaatQ==
X-Google-Smtp-Source: AGHT+IH4eca+ayyXMiX6Dn4FxVVDcDun7L0tc1YVtL6dDvZI0RKFR3m0GCqDAJcYW/P4jHfqxA1Vyg==
X-Received: by 2002:a17:902:ea08:b0:1f6:5013:7842 with SMTP id d9443c01a7336-1fa23cd95edmr115136565ad.27.1719395060751;
        Wed, 26 Jun 2024 02:44:20 -0700 (PDT)
Received: from [192.168.250.115] (50-37-31-88.grdv.nv.frontiernet.net. [50.37.31.88])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f9eb3c8c01sm95699755ad.129.2024.06.26.02.44.19
        for <kvm@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jun 2024 02:44:20 -0700 (PDT)
From: Todd And Margo Chester <toddandmargo@gmail.com>
X-Google-Original-From: Todd And Margo Chester <ToddAndMargo@gmail.com>
Message-ID: <d2dfa321-742c-4e8a-9747-1c00a76e2bcf@gmail.com>
Date: Wed, 26 Jun 2024 02:44:18 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: How do I ShareHost Files With KVM
To: kvm@vger.kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi All,

Fedora 39
qemu-kvm-8.1.3-5.fc39.x86_64
virt-manager-4.1.0-3.fc39.noarch

Windows 11

How do I Share Host Files (Fedora 39) with
Windows 11 (client) with KVM?

I have been reading this virt-manager how to:
     https://chrisirwin.ca/posts/sharing-host-files-with-kvm/

He is leaving out how to mount in Windows
and his "Filesystem Passthrough"

https://chrisirwin.ca/posts/sharing-host-files-with-kvm/add-filesystem.png

is a lot different than mine
     https://imgur.com/pqPcLo0.png

Anyone have a better howto?
-T


-- 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Computers are like air conditioners.
They malfunction when you open windows
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

