Return-Path: <kvm+bounces-60071-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 65988BDE573
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 13:52:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 3496C5041CB
	for <lists+kvm@lfdr.de>; Wed, 15 Oct 2025 11:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2427323416;
	Wed, 15 Oct 2025 11:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cZMdkQ5H"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AC4B3233EF
	for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 11:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760529142; cv=none; b=TAcmaQR3GyoeYoXEuNVIOWlc6d9shy+kKbr07IlmFY+QWbmBbldyuORbDhFJFNc8r8kLIzXbA53bGm31ioQXzElcQscWFyfybzsry/i/X63POcYnxVe/IEq0bOJDqik5sGQnLS12fsv52YRwIewfGOpkma/fPvKvr8wK8gkNR3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760529142; c=relaxed/simple;
	bh=fDR4DR3lXtOdJFgzgLDXGlSiJF9G4ZPfo/kcgyBglSE=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=Dia2kzOJVC4qdad1rU3ODCXPUqHL+1mB0V2P2l0TlJWsZ8sESEmrkBHePK20iqWHSsdy8TPKtbK7Y2fyv21Apt54xZzePZwGR/nuYovyv7zRVQhMEpLVs5b5uigXsedUxQbLrp5rYyZMrQrqO8wS6sJgq2ll8yMTFCw1/CeMz7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cZMdkQ5H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760529139;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=pedxTOqCnDHcJWjHS6sMRZ0lAfvMDjf4A7k3dRzT8q0=;
	b=cZMdkQ5HrpjpY7iPwp5cV5YIkg0Ho5G6GVm4pLi9Oak1jTJQY4CLrulGyMtcZF8FVO6YjU
	qMCZtgIcqo6qm0paWxe3EslucRw0ndphGenRFBgGuxotTNZfz8hZF6b9QosSg/bEFpgsjV
	kK2u9FQYbBi9kTFN/G36svQc8+esn1g=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-372-psoFBt7sM1-nqnk6antF_Q-1; Wed, 15 Oct 2025 07:52:18 -0400
X-MC-Unique: psoFBt7sM1-nqnk6antF_Q-1
X-Mimecast-MFC-AGG-ID: psoFBt7sM1-nqnk6antF_Q_1760529137
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-78117fbda6eso9192356b3a.3
        for <kvm@vger.kernel.org>; Wed, 15 Oct 2025 04:52:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760529137; x=1761133937;
        h=content-transfer-encoding:autocrypt:subject:to:content-language
         :from:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pedxTOqCnDHcJWjHS6sMRZ0lAfvMDjf4A7k3dRzT8q0=;
        b=T3jViBoV3kDSDPE0zi+1ASwKRRqnNcZKOZDoj827qBQm83MCqsIkvNHKtm9OmBmF4T
         Xa66fSc+qYHth10ZvArD5aAFud82u8pw11fz7Ntlm+m8WH2ShWV4bOuzHBs1eQzGMIu9
         Vg1ZnlSaqac5UlOfEB8s53alFCp1DzwKe/sSRWFgB6Q86tFQqsGeAn/om6t+YLG5IrJ9
         KTvQIPaB6rap+dNbFfyP/AWeDcqsKOpdN8FR9qzYU/Pu0fViKpHexkGHs0TifzYCgxfv
         xqeO5pRDYDIvpb3XS4+VavVxGxLrrCnAu+QfgPyGKoB5m1HiXUSpZKkLorWf9Cht8g7e
         TU0A==
X-Forwarded-Encrypted: i=1; AJvYcCWtbOS41RLbY/T0/XzuZYyKGqI824MJ/D2qlizGDUh3a/9FfrcBGzBaFgB+tdFhJ+sGDSY=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2ah47cY4pueJTXDhG4r0mmtcSWEra38B7iJV2H16DifXbkO/M
	tjbV0lLOODkfKdr3ERFiBfsSBU8Cem7T3bU6cYDVt1xwkXctY5M/0J76ZCVNenLwPFDbnKRBX9m
	bclBZp7rEtZe0L0OKD8tyheoCvTobRBXr/RGTvuEvp0Pyf1eczp4LXQ==
X-Gm-Gg: ASbGncs43ZFnsrs6vkaPYd+/jWXEm9aolnRt+xKqceV/sM/kQz1iHPB1Y+o1UrObZ2w
	g6Pe5454NcfVIDbcqm3ORUXVEU2HOS4CHLlKm9I5Fn5W5dWhIL7j4EQWXRzeXKQu4OejqneuPPY
	ZX/MMKdmFCDCHf2UKhxcqfm71DeQDruVf7bf84R+NWHTvSY24tHFR1g5hhlkWxzXGmXnYQ1zoWj
	GWqPzbGZCSDhSCg+GlNOsg5tRX1jjxT8HzS3VDIXKLI5eZK9trOU502tmmTEweRp+NWIVZSjBrz
	y74/F4KW0t0FkhC10+Y0GeG/Q4qNxADAPqVR+klvQgDjoYpfkucwxsJrGl9s+3M=
X-Received: by 2002:a05:6a00:391a:b0:781:220c:d2c1 with SMTP id d2e1a72fcca58-79385709914mr35986747b3a.2.1760529136937;
        Wed, 15 Oct 2025 04:52:16 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGb7SrqycHuadlwdELKoeyFjQEpGJz99JROKqikDtE+OMa8GiO3fh4r0L35lafaemYLXPK3Jg==
X-Received: by 2002:a05:6a00:391a:b0:781:220c:d2c1 with SMTP id d2e1a72fcca58-79385709914mr35986708b3a.2.1760529136392;
        Wed, 15 Oct 2025 04:52:16 -0700 (PDT)
Received: from [10.32.64.156] (nat-pool-muc-t.redhat.com. [149.14.88.26])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d2d2e42sm18235247b3a.62.2025.10.15.04.52.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Oct 2025 04:52:16 -0700 (PDT)
Message-ID: <df452f66-7113-4842-b2fb-7752ccd59e9d@redhat.com>
Date: Wed, 15 Oct 2025 13:51:57 +0200
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: David Hildenbrand <david@redhat.com>
Content-Language: en-US
To: "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
Subject: [Invitation] bi-weekly guest_memfd upstream call on 2025-10-15
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi everybody,

Our next guest_memfd upstream call is scheduled for tomorrow, Thursday,
2025-10-15 at 8:00 - 9:00am (GMT-07:00) Pacific Time - Vancouver.

We'll be using the following Google meet:
http://meet.google.com/wxp-wtju-jzw

The meeting notes can be found at [1], where we also link recordings and
collect current guest_memfd upstream proposals. If you want an google
calendar invitation that also covers all future meetings, just write me
a mail.

To put something to discuss onto the agenda, reply to this mail or add
them to the "Topics/questions for next meeting(s)" section in the
meeting notes as a comment.

[1]
https://docs.google.com/document/d/1M6766BzdY1Lhk7LiR5IqVR8B8mG3cr-cxTxOrAosPOk/edit?usp=sharing

-- 
Cheers

David / dhildenb


