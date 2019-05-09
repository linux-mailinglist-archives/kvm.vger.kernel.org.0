Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F356518784
	for <lists+kvm@lfdr.de>; Thu,  9 May 2019 11:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfEIJNA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 May 2019 05:13:00 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:52184 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfEIJNA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 May 2019 05:13:00 -0400
Received: by mail-wm1-f65.google.com with SMTP id o189so2268800wmb.1;
        Thu, 09 May 2019 02:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=UcO77C1d2oPlXYkp6CkiRlKtVOMkq5wxTIYeAm1syxo=;
        b=CDkwyiO65SSVbxmKPkBw+7CcNdsw7cmG/lXhK57rnCu5hWuqjioqvSYy2l9aUikO5M
         /nW8VgaATNCzJhdIcK9nIZxH0TZfYz86n0vwCqqh1C//E0g2pG660CNOtzmxqm6EqpgK
         ZWIpx5vT9WYGFEmAXUpEgd/buHjfmaAOtX6UH2Bw+XR37DkBzqcVhOmXL2ZHV4oI4jxf
         Q6v6TKLWoy9BL+/a+HF5QnTS14Sj1q9oOGmb1RYruBTgAgXTxEzipUKxBtN49pQAYrNG
         4uZj/gIv9bT4vK48zVMSQsSJ5yDQ1b2WgQORXIz4ZaauynohR8iJft+JXpAWii7StqKO
         1cXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=UcO77C1d2oPlXYkp6CkiRlKtVOMkq5wxTIYeAm1syxo=;
        b=GHbMDfYvEaa6C85q8xjApQegAkKhNKpwdC6JFwukJP2D41N3ADfvFSiMwiftpU/ygr
         dLYpYxEnSca9u0vi66vbWGvoDKqsVyeThGPIR03kQD/CGLY5w4MGmTulB5MjGCxF2Gla
         ljcySJ0VOnSWMm4vEDeCukIvofeQTZd3ilhOOxk8s8JGWkNcC859OcfM54ZHSskaH5WA
         jwJnUC3zsiy0HYpbnjicb+GnVje5Lr4GZFK/K7p+AkbCLCy8qFhd4kM0oRWYVtmPbkf+
         P6TvvNujlFahf63BlUDRRGOr3NnnSdPlmdV0s1BMDCaqUAlUMOY3qIpgK0Yogdff0VQd
         ytPw==
X-Gm-Message-State: APjAAAX1QshsvAAJyC1SghQ8O+4OlEpkBzNraqZVk6jqHAYEmvp3PICF
        fDGYMpB/NdnioOKjYXfDtYo=
X-Google-Smtp-Source: APXvYqw0VKhI0WziMTaFb1wtWXZnzZOn5XxmOI7BEJXN6voxMBVpcjaeQu+MCIZq24v6HE7IT31/cQ==
X-Received: by 2002:a1c:b756:: with SMTP id h83mr1888506wmf.64.1557393177619;
        Thu, 09 May 2019 02:12:57 -0700 (PDT)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id e8sm4815404wrc.34.2019.05.09.02.12.56
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 09 May 2019 02:12:56 -0700 (PDT)
Date:   Thu, 9 May 2019 10:12:55 +0100
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, Fam Zheng <fam@euphon.net>,
        Keith Busch <keith.busch@intel.com>,
        Sagi Grimberg <sagi@grimberg.me>, kvm@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Liang Cunming <cunming.liang@intel.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        "David S . Miller" <davem@davemloft.net>,
        Jens Axboe <axboe@fb.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Liu Changpeng <changpeng.liu@intel.com>,
        "Paul E . McKenney" <paulmck@linux.ibm.com>,
        Amnon Ilan <ailan@redhat.com>, John Ferlan <jferlan@redhat.com>
Subject: Re: [PATCH v2 00/10] RFC: NVME MDEV
Message-ID: <20190509091255.GB15331@stefanha-x1.localdomain>
References: <20190502114801.23116-1-mlevitsk@redhat.com>
 <20190503121838.GA21041@lst.de>
 <e8f6981863bdbba89adcba1c430083e68546ac1a.camel@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qlTNgmc+xy1dBmNv"
Content-Disposition: inline
In-Reply-To: <e8f6981863bdbba89adcba1c430083e68546ac1a.camel@redhat.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--qlTNgmc+xy1dBmNv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, May 06, 2019 at 12:04:06PM +0300, Maxim Levitsky wrote:
> On top of that, it is expected that newer hardware will support the PASID based
> device subdivision, which will allow us to _directly_ pass through the
> submission queues of the device and _force_ us to use the NVME protocol for the
> frontend.

I don't understand the PASID argument.  The data path will be 100%
passthrough and this driver won't be necessary.

In the meantime there is already SPDK for users who want polling.  This
driver's main feature is that the host can still access the device at
the same time as VMs, but I'm not sure that's useful in
performance-critical use cases and for non-performance use cases this
driver isn't necessary.

Stefan

--qlTNgmc+xy1dBmNv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAlzT7xcACgkQnKSrs4Gr
c8h67Qf/cCzGWh6iM657Q87QZaDIfXuEdFC5VBJt+JUTAJrD1K+vJeppmlITSNe9
7i6nrm+Y7G2icJW5PZmv7Ym7Pl9na4VDNU+G13f/ErGEniwuY8YdvW5VyO7v8Ilo
ShnXoNT6DY0yhSi7TZalmpq/o9GAw/i0A/QEoMs89A1jQgcnbYZjXemlRTuy+RaT
NcXQxGSVvjW3QXT/qSiwD2GgeNVWbGTp5pCFME/GBY5tlad9blpJJIKkQQLHyhdW
U/UqokQr4hAbb1C1W+Y4nzQsGaHxB8AN+mQoD3luyDs0qqYNeHLiQCAm3mXdRna5
A/tkfOjwvZxT/OhJqWDcjIHB9NsWmA==
=YaAX
-----END PGP SIGNATURE-----

--qlTNgmc+xy1dBmNv--
