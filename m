Return-Path: <kvm+bounces-41718-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CFAF7A6C355
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 20:29:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6739E3A8CF5
	for <lists+kvm@lfdr.de>; Fri, 21 Mar 2025 19:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F4D022FE0A;
	Fri, 21 Mar 2025 19:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="n3Qv6mJC"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFFD1D54D1
	for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 19:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742585259; cv=none; b=Fgie/8lbslku0frsqRJHCYDiequR5P1O3tVMloZz10FMDbwY/eA8KpckrM/dVb3036W8qWoYuZ+MYK2J9yfMCSbKE8XWA9oHColFhUr3OTBH5hSqRLpnNrZbXI5O/keTFQH1iviAK5kfAhZQHt8vrqe4EFdrHKAAO1C97kVCAXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742585259; c=relaxed/simple;
	bh=XLwOE4coxCRIohvwB70j4ZgJyFFb+Hg88Q2H6uIFOZg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nn4dd/OnxGkS2myjbY9aU8/Ml2cgKwSQE1R7e2MQ6EkFoLm4drj1TD/QUwBiq5zIaqt4Q/dbwM71Fwgfap7ClpervwV+efYR+16oUz9HReYsVB+jvaACIkLzyL3DF4eVNUCpeHrPBd8rhVz1k4XeQP/esGF/fs3ZZP5rqzsOYYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=n3Qv6mJC; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-22403cbb47fso48154275ad.0
        for <kvm@vger.kernel.org>; Fri, 21 Mar 2025 12:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742585257; x=1743190057; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+BD4Q0d2ARlbHpJDDpX2hvCogsjsARu368abJg8rMPA=;
        b=n3Qv6mJCItX2lBHf9gEdouR0v2+f5mWmhLVr66P/IP61SIfvsnDy9FTMMlcX3YVVym
         ppB1xE0qJ/f+2vNwDZU1MLgA2/OSQebU9NJM+MiE9c3bs41tWP0KYtL70chGd6/V4QAg
         j65ywG6/CqDNxpgsdMNc06YNNA43YS7LHCNQwqG7A86H9LkzsmGzp5tDOuJ0asxo8wx4
         BhMamJAChUudysHj7PK/Jx/ynwU09kfSqvGi2BkKHQXpSrxoFMOQ5Ku58KVLajv7cq+9
         wRxahHvelpz89G0c72dGPigg/fs6Ju2hQ/rcOM8pWx8fMN0x6QcgofjouoAFos2P4rv9
         DvWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742585257; x=1743190057;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+BD4Q0d2ARlbHpJDDpX2hvCogsjsARu368abJg8rMPA=;
        b=VC0qIi4Tje4MQIBC9jVIfToFSyLYvruQ5zj9Swy3BmY+sOsiZB7GQyKy5JaC5QltYa
         TT5uc2Mgj3ZiUSMWJ5JkKuZ7QnG0kJ4uAEASuOnuBxtqo1Pit6sIh+p0EEpc7FbxeK8s
         ghkjWylMMmCwe5XnAJ6bx88prg/pzqbHevGPIoQTnayyrzckXOvuvfgJL/rBJudDILXD
         LTovVpWqhgAHYLX7PJTB7rtJ3evVT7rtTz6/wBdZsk5qS8nmi8oZ6Heti4uJd/eaVOvC
         i7vnER7IyF2wGJL76o9SOOaOq0m/b9O7qILo3WjpfCdoZvPCaOlRpNHP/YBm2DsW6/52
         MSfg==
X-Gm-Message-State: AOJu0Yyfb9ni1bSD1Zwu0jvmbYBHJi/LpCk/icpAsvzHGEx8Gp9YKT0G
	6neTU8VLcfthzrTn7vnGCdsRsRFJQcoTOpPVSlvoxnyhxmFRkumjRgJD/IOohFo=
X-Gm-Gg: ASbGncuJ+EetayssKzcn7Ofzf1fWfkp998KZDmpmBYWxOT+1sUNbWruPf9vMEuyrx2u
	8j3ZmGiA0veqO6ogOA0oqodMbXNgfv1yR8A1nARsp93uxITiQ0Th3552dmA2L/Pn9z1DoBeCEh1
	L/FtA60CmQL+ANF7uGR+IIh1TG8EAk1FxOQvXe3aKad1UsJC7fyLGq5GAlWL7mwineQMSpTkPD3
	VdKB/ZwXgAsJjXgwPInpoRP3lqpMSOaUef4CpMXnbjOgD+yZOET2Xg2/l5l2kRUYH3ciY1YJ9A9
	47/fFquurPc16oPNArjZqDmGv5lG8kmzCxO6TS3hCKW7Sk+F4Ikd5oBrhoUd+8DVLT/N3t2591f
	Or0u5TSOz
X-Google-Smtp-Source: AGHT+IGdwHtiK8kjlifCbPq40icJnn3e6WLjtJ4qO1xsRZRyjHJoCQKmv47WszcOxwOHmSQmmthTsA==
X-Received: by 2002:a17:902:e88e:b0:223:3bf6:7e64 with SMTP id d9443c01a7336-22780d8a93dmr69838655ad.24.1742585257089;
        Fri, 21 Mar 2025 12:27:37 -0700 (PDT)
Received: from [192.168.0.4] (174-21-74-48.tukw.qwest.net. [174.21.74.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22780f3974dsm21319225ad.7.2025.03.21.12.27.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Mar 2025 12:27:36 -0700 (PDT)
Message-ID: <a67d17bb-e0dc-4767-8a43-8f057db70c71@linaro.org>
Date: Fri, 21 Mar 2025 12:27:35 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 17/30] exec/target_page: runtime defintion for
 TARGET_PAGE_BITS_MIN
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: kvm@vger.kernel.org, qemu-arm@nongnu.org,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?=
 <philmd@linaro.org>, =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>
References: <20250320223002.2915728-1-pierrick.bouvier@linaro.org>
 <20250320223002.2915728-18-pierrick.bouvier@linaro.org>
 <2e667bb0-7357-4caf-ab60-4e57aabdceeb@linaro.org>
 <e738b8b8-e06f-48d0-845e-f263adb3dee5@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <e738b8b8-e06f-48d0-845e-f263adb3dee5@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 3/21/25 11:09, Pierrick Bouvier wrote:
>> Mmm, ok I guess.  Yesterday I would have suggested merging this with page-vary.h, but
>> today I'm actively working on making TARGET_PAGE_BITS_MIN a global constant.
>>
> 
> When you mention this, do you mean "constant accross all architectures", or a global 
> (const) variable vs having a function call?
The first -- constant across all architectures.


r~

