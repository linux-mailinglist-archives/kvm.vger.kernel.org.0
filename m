Return-Path: <kvm+bounces-12804-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DDB7788DCEB
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 12:54:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 961B61F29A8E
	for <lists+kvm@lfdr.de>; Wed, 27 Mar 2024 11:54:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EEB412C805;
	Wed, 27 Mar 2024 11:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b="bWXQaFvz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA86712C7F2
	for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 11:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711540470; cv=none; b=bAAk/OyNau3UE1rFiwmjxkjKpXpwVQWGItW/SNpOrwAoTNROa0uG7j3Ff9lmelyE83ENCHQ3hH/3kXyRp1PHB95oUtOafqXTeD2KW8l+yLMBUngR6ZsSxgdEGOnGPzNiMcrK4O0/mMgcvtA7Owqyag+WZGiGmiMZbwi8vF8+ucA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711540470; c=relaxed/simple;
	bh=DzYz2HhNcAcZLiLQYG0ve/CZMNuHGe4PjgfBC/pC1Z8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oSG7b5T9yJGNEkKIqcJ1vKV+DUEIdLwqubNflNxjp5xyfzS3S0benxA7xXtQ7nHNWqVHsQrqQvnAKYbZeViAxYj/5/THaVcmnxZ/cfd0vuRhP1HsYNeOwWJd+0o2v6K7bscn5tV2FFcWagKJ8Fa9/PqyGaLe1tk0zIEDxgr9ff8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=cloud.com header.i=@cloud.com header.b=bWXQaFvz; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a46ba938de0so883071966b.3
        for <kvm@vger.kernel.org>; Wed, 27 Mar 2024 04:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.com; s=cloud; t=1711540467; x=1712145267; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Xo2nfZBTCiRDB2jtZRoNWpjUBE4WiCL6rnHvacWUBJM=;
        b=bWXQaFvzdtTK+5s2jiS8u0XyDdH4FVfl8tz2vb9V82ONn+JfqyO98jDz3GVcBnMFJW
         9JFpLhMYSGSxybLa7F5zQePSY4HHk1O64YTZP0InTDByD43QKtoE2vf8njueruDNxE3t
         GAtpS8IaB5PP+fehT8vBPaF0fvm3TrFxQrbmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711540467; x=1712145267;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Xo2nfZBTCiRDB2jtZRoNWpjUBE4WiCL6rnHvacWUBJM=;
        b=c5St5fq9EBfxxrDywO8d6sc1CcBtjQU+F6Ut/ZvpQzj7q4EPgGqQUPVoM+e9Oo7T1s
         5/sMHlglnRddzYJPA8HZq/27Nwnlp8h7wIzdyJAVtldw+BRgSkukwap1YUVPlpZ4pTqv
         Ms+cnMnt8510xSmNsUofW3ZJxzl20tmjMDkhl+s1nAZJPc0ixlTFFxRxuAsfNLfZ2v+v
         vOOllW0+f365CARgdEZuJMy9OmX08PnBawC1URcbS1mwLKoX7+8WBCOWe3uu35jcuQPB
         FkR2C+R+cW5DSDimisfLw0VqRDbbDv/NFgyiA0bfDH4CtmeNHOyiE0QsCUFHNT7ifPu8
         vq7A==
X-Forwarded-Encrypted: i=1; AJvYcCVYNibguOg004zJuW8CRlcJHC95NRQzoI1SAj+2pi1LgtxS8QpTVn9ehpcHyeDRj9ZhKuQmhL2sJSK6K4jGetqhzNDA
X-Gm-Message-State: AOJu0YzyEZP3vdApuR8jwe9zyymszkwuE8ufAXYHzZm0mffPECbrz13W
	J4IOMLR6H1sramtrlFcQDYJjz/zVsghDHvnIQMbgyk63EP23Vo9uXeNUfVjs3/g=
X-Google-Smtp-Source: AGHT+IG9GlCL2qsgWyuFSglCpOBIwZX7MMRogX3VsIf8avJI3j19EV0AuKmIO9P0kiOttKpgN9U6dQ==
X-Received: by 2002:a17:906:1911:b0:a4d:f2a3:9c37 with SMTP id a17-20020a170906191100b00a4df2a39c37mr3310934eje.4.1711540467139;
        Wed, 27 Mar 2024 04:54:27 -0700 (PDT)
Received: from perard.uk.xensource.com (default-46-102-197-194.interdsl.co.uk. [46.102.197.194])
        by smtp.gmail.com with ESMTPSA id x20-20020a170906b09400b00a469e55767dsm5334791ejy.214.2024.03.27.04.54.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 04:54:26 -0700 (PDT)
Date: Wed, 27 Mar 2024 11:54:26 +0000
From: Anthony PERARD <anthony.perard@cloud.com>
To: Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>
Cc: David Woodhouse <dwmw@amazon.co.uk>, qemu-devel@nongnu.org,
	Alex =?iso-8859-1?Q?Benn=E9e?= <alex.bennee@linaro.org>,
	Paul Durrant <paul@xen.org>, qemu-arm@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
	kvm@vger.kernel.org, Thomas Huth <thuth@redhat.com>
Subject: Re: [PATCH-for-9.0 v2 08/19] hw/xen: Remove unused Xen stubs
Message-ID: <7af32170-a282-4f28-9db6-913087960acf@perard>
References: <20231114143816.71079-1-philmd@linaro.org>
 <20231114143816.71079-9-philmd@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231114143816.71079-9-philmd@linaro.org>

On Tue, Nov 14, 2023 at 03:38:04PM +0100, Philippe Mathieu-Daudé wrote:
> All these stubs are protected by a 'if (xen_enabled())' check.

Are you sure? There's still nothing that prevent a compiler from wanting
those, I don't think.

Sure, often compilers will remove dead code in `if(0){...}`, but there's
no guaranty, is there?

Cheers,

-- 
Anthony PERARD

