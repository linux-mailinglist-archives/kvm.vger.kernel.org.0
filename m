Return-Path: <kvm+bounces-10144-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D873886A1B4
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 22:30:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8E25D1F2E319
	for <lists+kvm@lfdr.de>; Tue, 27 Feb 2024 21:30:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1AA14F9D9;
	Tue, 27 Feb 2024 21:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nIKpG3lk"
X-Original-To: kvm@vger.kernel.org
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DD514EFDB
	for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 21:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709069397; cv=none; b=iAKuyTbCEa5ZyU/SRzFL9GtqUvOIwYSMSkhdx+9v/URhKH4E8FSfaQlm368Sl5dYQzBpfeChEmBHmtX78F1j9PIOzS3DTgutlnao/bUujJIz7kWBTaNxiaPN9T218OY0v01nKHbxwxcFiY0LUlWM0al7F7WBU9rW3gcs+EGG4zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709069397; c=relaxed/simple;
	bh=rIJ88V/tax2NVL6+s5zvK1X7yO1VCi2lK4BLuDBl1jM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=elnFFrvkrKgnoM56ctY8PRdAtrmNDVrf1cT7wGHm291Rr5D1pX2Zx01LzG5kG7I+dSxJpkts+qZHf+xE3DJWkzIlDVUBA+5WZtAnwYJflf/IZ3JCJIdIZwLlzcYD5jkqvgQmEFzfeWpSuNqaH5ZWZSWcgsjH+SCsNRsN9Ql54wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nIKpG3lk; arc=none smtp.client-ip=209.85.219.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-dc6b26783b4so5938884276.0
        for <kvm@vger.kernel.org>; Tue, 27 Feb 2024 13:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1709069395; x=1709674195; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=N1u5BW5TjNAUcNNWbLgeCkfXH3SJ+Dkjz6FwWTFOoAM=;
        b=nIKpG3lkXmLWo+BoVsm56aWMoEsE/oXMbrwKxnoWFzPGVVKjZTJP+oU1U6uhYtyfPU
         Y3ShS/eA3libhFwiYSR0TTAxsnpyS/F996063R6G2cAJWM1Hy1zJkWD6zsaxFrONYz2b
         BnIJyfvLjuLtx8D3YaSKHxBGZIM7lc6rAUXjb/ZjDwFuLTJ1OHg4yR7IV11ZAXM/ZICN
         YvpopKgzWEP7EWTsVk/3UvoJO5T4NtCr6KeYoKrvaYiI/k6NKkmPNPbKLS0l+Rhb5w6u
         ++KLA6ryAepjMxIwGIuq6VflNuRElt/5XVpTxzotQFDHInFlmDLa9jzSEVkreXHBD8fv
         zjXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709069395; x=1709674195;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N1u5BW5TjNAUcNNWbLgeCkfXH3SJ+Dkjz6FwWTFOoAM=;
        b=tgkooWKhs/F0vJBeJzjbGlUvp8/MTg2JjKDOn7vhfzi2E7120YWoaBH+R0eB3B78qZ
         xndbTPKeywMIIgPIDVhqx6iVPOZ4P+o6VxQYlGjboEaQdU1KkbEj4YtG/0swHqK0xjv3
         au/BWTY0vR6vOEZNCD5K+GfUheLdvoAERlzNDek/gUZCIv8zUxj2iISh5gaFgqyfkqlg
         7G7V4uuHGquBAF4184lh2klUgKb+3jqOUHrKWckLtmcuSUVLw8YJ7T5A9CLBrWCtPWYC
         3v7rUJaVafWez2H4f7X2ClDiGovxLZRYDE02ePxOTb19TUavp6va8e06TRueFPVzZeGK
         PI0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUJEQKXiZG5FounfsxSp2llnbVdQCRi9/TbrqASi+hr5S/btuJRynlpk5LZQFA9rQqf/kd2E9yCW5piE7cD+VBGxv09
X-Gm-Message-State: AOJu0YwGzNXINQt/NDzGsbBlVXNx6UXTt8C06oxpXIsSrr2gFNNSXvO+
	qCOpSKwhAcdh/7I2LDYnxBpW0xJnKbDN2O4J5sXeaNoopxh6myaS+KNl5M3MV0XS4F8Ci7znkew
	Abg==
X-Google-Smtp-Source: AGHT+IGazU+KPE8nu6wnjCFcCHmiJO6Upez3suJ4jvSyuNFIOpHZPK+ySHvTniCbWEqCCkaz7BIpbqbivSM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1891:b0:dc7:82ba:ba6e with SMTP id
 cj17-20020a056902189100b00dc782baba6emr54802ybb.7.1709069394930; Tue, 27 Feb
 2024 13:29:54 -0800 (PST)
Date: Tue, 27 Feb 2024 13:28:16 -0800
In-Reply-To: <20240227200356.35114-1-john.allen@amd.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240227200356.35114-1-john.allen@amd.com>
X-Mailer: git-send-email 2.44.0.278.ge034bb2e1d-goog
Message-ID: <170906539667.3824343.10867999255321122858.b4-ty@google.com>
Subject: Re: [PATCH] KVM: SVM: Rename vmplX_ssp -> plX_ssp
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org, John Allen <john.allen@amd.com>
Cc: pbonzini@redhat.com, mlevitsk@redhat.com, bp@alien8.de, x86@kernel.org, 
	thomas.lendacky@amd.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"

On Tue, 27 Feb 2024 20:03:56 +0000, John Allen wrote:
> The SSP fields in the SEV-ES save area were mistakenly named vmplX_ssp
> instead of plX_ssp. Rename these to the correct names as defined in the
> APM.

Applied to kvm-x86 misc, thanks!  I put this into "misc" instead of "svm"
purely because I already sent the SVM pull request for 6.9, and the only other
patches that are SVM specific is my SEV-ES VMRUN series, and I'm not sure I'll
queue that for 6.9 or wait for 6.10 (and I'll probably throw it in its own
branch regardless).

[1/1] KVM: SVM: Rename vmplX_ssp -> plX_ssp
      https://github.com/kvm-x86/linux/commit/78ccfce77443

--
https://github.com/kvm-x86/linux/tree/next

