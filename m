Return-Path: <kvm+bounces-18526-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 15D3E8D6048
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 13:08:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C18B31F23925
	for <lists+kvm@lfdr.de>; Fri, 31 May 2024 11:08:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28D20156F5F;
	Fri, 31 May 2024 11:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hykQcx0F"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05D20153BC1
	for <kvm@vger.kernel.org>; Fri, 31 May 2024 11:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717153673; cv=none; b=rIqixn3ZVMNYOlk+3JmvQ8VU6wTxm/78Q5ENyMlHsrJ0Bxxuv8ll8TYXno04vWaJEaUttbPGLY24pV0wM6rkBXhPMsR5k/lfgyrGxostVD+DdQ6GcMEOs/Yqm+nPRemnjHKbdYkkx2KLu4bL4obigZe/FD+2PI4Gm+cBf68hXTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717153673; c=relaxed/simple;
	bh=ux33iWT57euxpY/KPtF3GDlMoz9YA718mQJDVnPM0ls=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PiWGvm6dCFxbLpCy5uC5PW2mafOfeqDLU9XFbt43lHSAc8A1WbCzjMqxojeDZ34rzNACuPFOAMQzsCw7lQofRyitc8rZqnP6Zx4CeSJ0dVPBsrnIYn08lopDzGqhX1CRpRvltEh4JFDyiwr4++JYsQsIZFuKs4KOypIJnQ0lhfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hykQcx0F; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717153670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iH6814M6CLVqBXpSPkd18wok9isfcryqNjvd+sAwqaY=;
	b=hykQcx0FflC76HhM6/dbIZWRAyuvg3NwQkBDgoPwmXJifE017cSSq2ldnnhidTbhn8V3wl
	zna+V3zYVtULbsoSrq2cccG/rXSUgeN0nPLruMHEzlou53E/ScEYW9bxPilwPA7bRrcMaJ
	Im/u/1xFhM1h8WGGB0yxqnbwu/unkIE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-G0crEb9oP6yg72wQvXaidQ-1; Fri, 31 May 2024 07:07:49 -0400
X-MC-Unique: G0crEb9oP6yg72wQvXaidQ-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4212a4bb9d7so10327935e9.1
        for <kvm@vger.kernel.org>; Fri, 31 May 2024 04:07:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717153668; x=1717758468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iH6814M6CLVqBXpSPkd18wok9isfcryqNjvd+sAwqaY=;
        b=iAe0kkLSknsuMRNPEgXwEBPQKLFHcNB4jOCbSpZ7SSFU0/S7RwZ48LxgOmtBHJDwAM
         5F19Kv4+pQKUFPzhzCJq00xCiMW9SZozOql+G2N8zXZK5DA/h8qnMFL/5pXx+Z1sH8Ke
         FJPRXGL/FcUtnyZcliIlJYfXwhSqOIlgvM81oHomEF7tu0D5KPNhWMmiqgf76HzM4eZF
         VoeFIF8gbPniXSO5VdP7jUWcelhcMXaDMVNJ1HIYFovDOSJBuJC21BzaFk0gTBLa10yC
         388Z2cPgH4lshGOxCOliKiHFeu3qxmDjyI5wcDA9MNhO6sOAoXH9DIJBqZpIRAASOQrl
         1ExA==
X-Forwarded-Encrypted: i=1; AJvYcCWAYblSWqsDerJQqIANnciJ8ZjToW5iviVDHppDSVc2ZSPejjitj3JGJdZpIJYYWh5K+hNNj8vke/l1qHA9xUFOpZCU
X-Gm-Message-State: AOJu0Yx0lYnvtwbvQu4yX2lH0UMv/UVI87FkbUTeoSybgJjatLiV43sf
	WN7jX/OYK+FQFETDxamND4wyhrjbdy6B1e4vZqjteSqMyQ6GEkbHry2mqyKtboc0zap1nSXkJre
	dgEHycDacvI/WBUT19IgFjznJvYVM75Fa7j13rvZAs0Ss/dp0qNth8sj7DtIg0NtqeARdaBpqCW
	euHYPxanqb8Q0oUgox8I+AoGKq
X-Received: by 2002:a05:600c:1e1d:b0:421:20ac:1244 with SMTP id 5b1f17b1804b1-4212e075a15mr15889755e9.22.1717153668154;
        Fri, 31 May 2024 04:07:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFVCeTTmAfeZhjXbft+R7KCnt8s4Sg0ltsofJKok1rn+6rz5ca0Uta7glnMolOcpc/ztFG2ZKzqyLSx+s0DH8=
X-Received: by 2002:a05:600c:1e1d:b0:421:20ac:1244 with SMTP id
 5b1f17b1804b1-4212e075a15mr15889535e9.22.1717153667821; Fri, 31 May 2024
 04:07:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240530111643.1091816-1-pankaj.gupta@amd.com> <20240530111643.1091816-11-pankaj.gupta@amd.com>
In-Reply-To: <20240530111643.1091816-11-pankaj.gupta@amd.com>
From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 31 May 2024 13:07:36 +0200
Message-ID: <CABgObfbVb-=QiyDMKBHarrmr5pxs2NudKPCLZZgvCX14as2SDA@mail.gmail.com>
Subject: Re: [PATCH v4 10/31] i386/sev: Add snp_kvm_init() override for SNP class
To: Pankaj Gupta <pankaj.gupta@amd.com>
Cc: qemu-devel@nongnu.org, brijesh.singh@amd.com, dovmurik@linux.ibm.com, 
	armbru@redhat.com, michael.roth@amd.com, xiaoyao.li@intel.com, 
	thomas.lendacky@amd.com, isaku.yamahata@intel.com, berrange@redhat.com, 
	kvm@vger.kernel.org, anisinha@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 30, 2024 at 1:17=E2=80=AFPM Pankaj Gupta <pankaj.gupta@amd.com>=
 wrote:
> +    } else if (x86ms->smm =3D=3D ON_OFF_AUTO_ON) {
> +        error_setg(errp, "SEV-SNP does not support SMM.");
> +        ram_block_discard_disable(false);

Unnecessary line, there is no matching ram_block_discard_disable(true).

Paolo


