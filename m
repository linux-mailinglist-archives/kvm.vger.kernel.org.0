Return-Path: <kvm+bounces-67794-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C384D144F1
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 18:20:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7D5CD3005088
	for <lists+kvm@lfdr.de>; Mon, 12 Jan 2026 17:20:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E98378D9B;
	Mon, 12 Jan 2026 17:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GFIGoGG1";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="hkrtaQnJ"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47CAF378D85
	for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 17:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768238401; cv=none; b=jgLKFq9CdTU2cKyET4Fc7WRfyDqKezhD2Ut/S5NbfRapZEo8TTHY/4oZ2LD1k5fKKhPaM6/YdLoitAF5TjMFr/pSyKe+aqzHCTBEV0P8vHXZkA9Sz7BZBINUB5a417gSZ9HmvsumcT6jW93I5lRBdn0UMxSc/umXF1bowI1w7Ac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768238401; c=relaxed/simple;
	bh=b7oiNMreoFLjjoVmebL7QUCNbrobvYcybdrUIAcNIfU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Gx6tpBH5C51Rb6WYBQmDvYr9NPLFuzjxtA5CXr/KJoWMW4+/uSidM6ayWm0OO7aP7NOL2VtJXBwU9FTP7yVHqhcm5Oq+7s+rZTp2emgNzSnEbg9HrorrB2Rp2uHgxZHRwp8p20Aae6CI7WdEW0AnSZ7vfLuK4DUzWS0sOHGNVLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GFIGoGG1; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=hkrtaQnJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768238399;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2/79j6iZ8GygPD7Qnvz4ISA/UVU/GSE0d3luZMVts+k=;
	b=GFIGoGG1zUktocqUn/1Zp5tX0XrQeAvQ7Z80SFCl4/cZ9FkQww2QO5vlkoM0UX1nX9nIed
	cYbWIHEQoCaiSkcR3ycfb56oHAlMCBy5tNilvKkpcditZYWwVhf3PM5A0z7VEOLAQvNwbW
	cthLzUfzutj6QmYTzTbWqtMAsyC5cuw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-448-AXIfxP4xOyC_Ssqxa4g0Pg-1; Mon, 12 Jan 2026 12:19:58 -0500
X-MC-Unique: AXIfxP4xOyC_Ssqxa4g0Pg-1
X-Mimecast-MFC-AGG-ID: AXIfxP4xOyC_Ssqxa4g0Pg_1768238397
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4779d8fd4ecso28941205e9.1
        for <kvm@vger.kernel.org>; Mon, 12 Jan 2026 09:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1768238397; x=1768843197; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2/79j6iZ8GygPD7Qnvz4ISA/UVU/GSE0d3luZMVts+k=;
        b=hkrtaQnJYJuLkPvDx1qw3RajeZPIM951g+MEJcpy/TZvhIQZIzWn77k8vm4LYXsceB
         4Ughw4fWjY9yOnD1SqTQR3ylwM932xKxzegH036H6zX3tZBlYNWJABVrRGKv4xvXOnLs
         b0byhj51HrLgARpGN07Ypy1L00SNgtz7Z3aDWSFvA2bijVfT71m2+Vt4o1Rrq8tRMcwu
         meCpxzqbuUVYutqtIh6uzBw5kVGbwUuJm4Lg9p5L+vtSc+5mxbD88s/zWqYBAz1ptW8I
         HZNI1afvp1yhIfGE3evmEhJXF9ws7v9X4dnz86JrkiVRUg35Lx+tWgeDeBK+Ih7cm2Xd
         qADA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768238397; x=1768843197;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2/79j6iZ8GygPD7Qnvz4ISA/UVU/GSE0d3luZMVts+k=;
        b=GiU6Mt0/D9tvHXCGHXbJv3cVetqHRb57aSQD3wT3iPMx8gKRkDj/IJYBDjFYc/bfUk
         zfxgw7nn42WvxgGhHz4v5w/WqSkdaFrf5N/yhKuG4Voh/TReSa3hNSIKkuvaQCFD7Upz
         4xAaFLQ15XBtcX13ddhYO+UZe7K+5NScHOcPqaaZCm28eYPEajJh9Z2GqkcIpQ8adHvz
         XzawSbcAwP6B6afi0j0I68DWfdON5H8z9pnUpOLTLkRBdEWnAB3el3v/h9QnCvtNrRDn
         MzVk/a+hzCF2CdCP477jt0ib+XCzI5Bd5cEWDuKw09gXcW9TCeHNmdU+e1yDDR6tZXvi
         ySvg==
X-Forwarded-Encrypted: i=1; AJvYcCWbkfiQhZiRgyYSGT4LyFteXO3D6ikj7/zF4m7tLvszit+RY/bOvoD26BDLVMPNnoIlHyE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxJCb3f8mCP1g915ReOp6MNJ4V9CdqYWoE+P9p6eCv/EyvL3ptA
	BWvr71FjEo941vVdUctzbG22Il9rpBAgw049wUMImQ4kJ2FcL3cy7JgMIEVjyGAgOmdgwZIwvZ6
	gcegjOmgVDvlPLY3QMiRq3f1oYZOt1UAJINzgp7lbNvF2Bam3MTU3JpWyfBLOp6dHnbxVmOr+12
	/ltM+8BeyV7kmUuSdeWBpsBo9hlHeW
X-Gm-Gg: AY/fxX4rVMwM63y28FLbDlVwrdN1E1CsqUgGnbX2r7wwK9MVwgz5yYrtNNryzatqHxj
	NGZKkb+S7drMy6XY91UE45dST/AltiY+euaCXCPclwGQPbIyTkOFbRHRhhf9Z0kCFGdbak8tfuW
	/5gCHyJCK52OLfoVWFmXi/0EW4SbHYlRZPnVBTs4acDsZxQX26WkF16ZiuZVwK7YEvq3dK3IWDN
	bpVKocBILCwdAKk3H/yHBRUqer3oZ1tDu02ivhN/MYB7WT48RpMimgL9IrjzF8gOZNUWA==
X-Received: by 2002:a05:600c:6a95:b0:47d:7004:f488 with SMTP id 5b1f17b1804b1-47ed7c2843dmr1455455e9.10.1768238396813;
        Mon, 12 Jan 2026 09:19:56 -0800 (PST)
X-Received: by 2002:a05:600c:6a95:b0:47d:7004:f488 with SMTP id
 5b1f17b1804b1-47ed7c2843dmr1455195e9.10.1768238396465; Mon, 12 Jan 2026
 09:19:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260112132259.76855-1-anisinha@redhat.com> <20260112132259.76855-26-anisinha@redhat.com>
In-Reply-To: <20260112132259.76855-26-anisinha@redhat.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Mon, 12 Jan 2026 18:19:44 +0100
X-Gm-Features: AZwV_QirRKZFKxjgCZydqAV1KubY6QZS9O35MXViLqeftOcbpRGTDiqhtJGr6bU
Message-ID: <CABgObfbA_SODCgRFkX61nt+tdGK7txurUXo3yLbSuMfnjyyG8w@mail.gmail.com>
Subject: Re: [PATCH v2 25/32] kvm/xen-emu: re-initialize capabilities during
 confidential guest reset
To: Ani Sinha <anisinha@redhat.com>
Cc: David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, 
	Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org, qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 12, 2026 at 2:24=E2=80=AFPM Ani Sinha <anisinha@redhat.com> wro=
te:
>
> On confidential guests KVM virtual machine file descriptor changes as a
> part of the guest reset process. Xen capabilities needs to be re-initiali=
zed in
> KVM against the new file descriptor.
>
> This patch is untested on confidential guests and exists only for complet=
eness.

This sentence should be changed since now your code can be tests on
non-confidential guests (or removed altogether).  Same for patch
23/32.

Paolo


