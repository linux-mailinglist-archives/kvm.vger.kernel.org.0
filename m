Return-Path: <kvm+bounces-59228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 467B0BAEB40
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 00:24:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B92B119445FA
	for <lists+kvm@lfdr.de>; Tue, 30 Sep 2025 22:24:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F5F22C374B;
	Tue, 30 Sep 2025 22:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OFaH45YP"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA532C3251
	for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 22:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759271035; cv=none; b=mKA2mjE5bVZlXMK1HWNrkBwRcpZFC56Ap/xFELPp7A18Ta0m+wGuMATG605HI1F9q+hF8X36oj32G9pgupPQ4C+tzT/q1jwXR7STuMz+9Pue124GBmHm0AYeJ6dyzbgNamp/bJTrS5OIVR6xo/gP4e/ueerg/6VDEkFD5DzzCBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759271035; c=relaxed/simple;
	bh=akVWlDti6Yox1LgORdnkES1etQivgEHJY1Xts9mvRoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uNYEK6LSSrV7+5YHF4YIq4mq1a2OddL1Z5OyHAQ267Za1NYhoLTJBoM5lGNNEJyJvHihB3X2Rtm/rO6mL9Hvm29IylUdoiWU533LYlUAKfePGnFfMj/rphNE3UcQECAlNtnFA+HFEjTm5PRB8lP/U9SL4lvcVM8R4MMx+da26W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OFaH45YP; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-27eeafd4882so84275ad.0
        for <kvm@vger.kernel.org>; Tue, 30 Sep 2025 15:23:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759271034; x=1759875834; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OovWlEA9+Pzbq4UuSlKiI00VjEkZNQJKGvfeEXc2tY4=;
        b=OFaH45YPjESLqqcCRUOiLhTfHOWsJrt8SWYz0KQScJ9aYnMtb+oTBnU7wMDKNftw2q
         Vs8HIfAIySnodCl5vPNAIfZIi46jxo8VN7O3yxpPYCq9eR5fsAX3x6MxoZVPMq7wPnDU
         QUgoBNxdztRUuqRfefI0welmeIJRf9clTlRHKmVn4At3ykclCoVMeCRZDB3aCvZ8m/fY
         TJKzWpGrBSjW7nyYpx7wScet3r9PnXpfh6k4KmDe20M1LOuWNP/MPPQrSmvUNRsfIobA
         TeA0dQjbBtIbbIel3AfhjbMkyhRpO6XsUZ3Rcb5jyazhqmIQ2tiWjx0vmVf4p67lloGF
         6few==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759271034; x=1759875834;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OovWlEA9+Pzbq4UuSlKiI00VjEkZNQJKGvfeEXc2tY4=;
        b=EOclDINAwA1ZlCoSKzGhArjFaayrnpvZIBeGbbeEsAI7TmhWQzlEX/2vRCLizGfRll
         AGyf2tI9HzgwRkjs3T/fmTtR2l+g97k4DYecschQbwVA1sk6L0X4qXX6GcjaCNqkn52w
         Ta1rV9QPAvYgE1k9cKvs/fwVujxTlabUN+6wJN3MNAkxVOSt9hUPIRY/Wqb3jluSEQA5
         rWfucWHLqH6w7lrCuzwhE8LaOOeaTDznYWNdrfXUUSD+D9chhgaWtd13vPg3t5j3Kyl8
         JHtrf3jc6bRms5OsVDPnsUT3lmKBe7s2i6cmimFxBvt0ldV6w8QYVpwlNTUL4WsTSjHG
         Z28Q==
X-Forwarded-Encrypted: i=1; AJvYcCUfpoYeMSFP4E2+2+IiQN3W9tsm0ofRRLnJtCz8hcFDrlfA9pn9axQ+0NIiTXF8u/bETW8=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxc3DZg5VJMOxWWV227cGKI3G95McAjdILWSzVN9FX2p3oDUwM8
	HARKmpJpvQjAX1cxcm/oaaliGA5v32uBMgv7ZI3dFH42wt/AvCCi0vgjn+9cUJeAKQ==
X-Gm-Gg: ASbGncvzqlo1L5BGz7uchyAeAGQCmotrcV/lOJ6rUmqes3vKQhxKBq6hjSrcl9v4wF5
	N27PyQX0N2lQ00qVuIo8OKtXnKBfuWVlagGi/Z6UMrmF3QqlzSA5XzD1Ru+XKY5rUCCZT93CcQD
	5lNpB1CSjqe/Gu7kDs52qROo2JE2LfJ02NyzN6pgOT1eYboCYmkrR8pBN+Kq4aKOLy8z66rFrrd
	SQ/RLoeKMSAOXNW1EFwmecFamGKAyXT2uS6NTjpft0Rkb2aGTfkRWIoWpc2eGcreSMpOKI4xGWS
	0HWuTxZFtng/50eRMyL3Xxl/o/RBGd1QoPvAU0cHodatN8xDMUIXbUlGl7JLaP1kOrpWFc8V6sY
	oNOSxmkC60dfxMMGDIXge6+OGyYceoxQ++VT5OByd6ksa3ny/ZZQIU9oXqG1zZ1Lm6zA1cAJosv
	Wb6qTb6iObE/+8cb6cypO+xg==
X-Google-Smtp-Source: AGHT+IG7yXqqtZNgHXq2ux/pq6R5lOByc3Up0+c+fpGZ9ajcwT8arb5aAkRLhIVwYDowJVib6njbyQ==
X-Received: by 2002:a17:903:1b67:b0:274:506d:7fea with SMTP id d9443c01a7336-28e8127b0c3mr707745ad.5.1759271033336;
        Tue, 30 Sep 2025 15:23:53 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6ab67a9sm167075335ad.131.2025.09.30.15.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Sep 2025 15:23:52 -0700 (PDT)
Date: Tue, 30 Sep 2025 15:23:48 -0700
From: Vipin Sharma <vipinsh@google.com>
To: seanjc@google.com
Cc: pbonzini@redhat.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com,
	imbrenda@linux.ibm.com, anup@brainfault.org, atish.patra@linux.dev,
	zhaotianrui@loongson.cn, maobibo@loongson.cn, chenhuacai@kernel.org,
	maz@kernel.org, oliver.upton@linux.dev, ajones@ventanamicro.com,
	kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v3 1/9] KVM: selftest: Create KVM selftest runner
Message-ID: <20250930222348.GA16152.vipinsh@google.com>
References: <20250930163635.4035866-1-vipinsh@google.com>
 <20250930163635.4035866-2-vipinsh@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250930163635.4035866-2-vipinsh@google.com>

On 2025-09-30 09:36:27, Vipin Sharma wrote:
> diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
> new file mode 100644
> index 000000000000..8d1a78450e41
> --- /dev/null
> +++ b/tools/testing/selftests/kvm/runner/__main__.py
> +def main():
> +    args = cli()
> +    setup_logging()
> +    testcases = fetch_testcases(args)
> +    return TestRunner(testcases).start()
> +
> +
> +if __name__ == "__main__":
> +    sys.exit(main())

Sean, as discussed offline, following diff adds a minimum python version
check. Runner can run on python 3.6, it might go lower but I haven't checked.
Linux kernel minimum requirement for python is 3.9
(Documentation/process/changes.rst)

diff --git a/tools/testing/selftests/kvm/runner/__main__.py b/tools/testing/selftests/kvm/runner/__main__.py
index 8d1a78450e41..db87f426331d 100644
--- a/tools/testing/selftests/kvm/runner/__main__.py
+++ b/tools/testing/selftests/kvm/runner/__main__.py
@@ -91,4 +91,9 @@ def main():


 if __name__ == "__main__":
+    PYTHON_VERSION = (3, 6)
+    if sys.version_info < PYTHON_VERSION:
+        print(f"Minimum required python version {PYTHON_VERSION}, found {sys.version}")
+        sys.exit(1)
+
     sys.exit(main())

