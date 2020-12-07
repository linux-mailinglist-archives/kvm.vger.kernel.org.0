Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812CD2D1401
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 15:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgLGOtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 09:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbgLGOtW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Dec 2020 09:49:22 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D103C0613D0;
        Mon,  7 Dec 2020 06:48:41 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id f23so19870125ejk.2;
        Mon, 07 Dec 2020 06:48:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vvj+sguFIHCuvKw9HAkbiDDdNCIhXEC7IvjtKCPDPx0=;
        b=BZSpRRfIVSET+efV/b/fBEgdvRZsvtUl8nALoEPcJGcqxLa/Apn59UIRsV5hCVQemL
         99P0WEtFrYVG/FWLP+j3PU8PLZ0A+rLUjy7w8jTWMhnB3TBMTTEZvLhBDyCVwll1ePFi
         2CQy7NLTHKmomtC5JUX5+Zw0iPRp37rt0cFtdgIKQGRSaS9w/L8ow00DoCGLfFKkpOYm
         E3ut6ksre/YMS5F+Q7gPpu7QHGozz934R1gaIod0b4H6lgbPfX98QsgkjrcKVCOWarqi
         9aJTzEX+RtTSGp+oMkSBKGThWdvHXAWbNt5qBDesfnYMayVBvM2lN4bzHmJIbEZB9DA7
         QKQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vvj+sguFIHCuvKw9HAkbiDDdNCIhXEC7IvjtKCPDPx0=;
        b=BQ73q6UQ3dAgwUVw1jI7FaNBAgQJw0bsbmUHu9aO/I02Uy3MV5V/cwz2KRNiypaZJj
         Bhqe4d2ud0GbQ4/xK6dNUgAG5TMcwE3RxxwLB2ejfpkkmtQVpcuoEa033rwDfJjCkBEo
         FMm+q+kHWzwobWqqx5yQ/q0xUzZIqTnY9wxBojX31h11poNtmvCLzlUTxrF0LgO3ArPa
         NJudufNq+6UiPJkZU5nkL3gixRM6nUB7ehiimPJl4se/Ok3pAGi7pHTPXw3ZnOsrD69f
         qW6uCrEJbulk7/hUI2zucJbRw5C0nU6Uquc6FcFLO3iAmgKCI2QZ14RqVCSrsjUcprxD
         eEYA==
X-Gm-Message-State: AOAM532OHBa4uRMG/UUTHBz2s7hfIeXCGP5s+HGLaYGjusH4NJ1b3Euu
        +WHqoor8Jixpc0BCaTR66EA=
X-Google-Smtp-Source: ABdhPJwBNVQ7yrztLvoTTpW0NYHawkNrb81krpaZzFsMcLKRhBi7EqHEIkHJIZPB4baoYYek6nlVMA==
X-Received: by 2002:a17:906:578e:: with SMTP id k14mr13885209ejq.90.1607352520379;
        Mon, 07 Dec 2020 06:48:40 -0800 (PST)
Received: from localhost ([51.15.41.238])
        by smtp.gmail.com with ESMTPSA id oq7sm2678535ejb.63.2020.12.07.06.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 06:48:39 -0800 (PST)
Date:   Mon, 7 Dec 2020 14:48:38 +0000
From:   Stefan Hajnoczi <stefanha@gmail.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Peter Xu <peterx@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Justin He <Justin.He@arm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vfio iommu type1: Bypass the vma permission check in
 vfio_pin_pages_remote()
Message-ID: <20201207144838.GG203660@stefanha-x1.localdomain>
References: <20201119142737.17574-1-justin.he@arm.com>
 <20201124181228.GA276043@xz-x1>
 <AM6PR08MB32245E7F990955395B44CE6BF7FA0@AM6PR08MB3224.eurprd08.prod.outlook.com>
 <20201125155711.GA6489@xz-x1>
 <20201202143356.GK655829@stefanha-x1.localdomain>
 <20201202154511.GI3277@xz-x1>
 <20201203112002.GE689053@stefanha-x1.localdomain>
 <20201203154322.GH108496@xz-x1>
 <6a33e908-17ff-7a26-7341-4bcf7bbefe28@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="yZnyZsPjQYjG7xG7"
Content-Disposition: inline
In-Reply-To: <6a33e908-17ff-7a26-7341-4bcf7bbefe28@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


--yZnyZsPjQYjG7xG7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 03, 2020 at 05:01:32PM +0100, David Hildenbrand wrote:
> The real question is: do we even *need* DMA from vfio devices to
> virtio-fs regions? If not (do guests rely on it? what does the spec
> state?), just don't care about vfio at all and don't map anything.

Can DMA to/from the virtio-fs DAX Window happen? Yes, the guest could do
it although it's rare.

Is it a great idea to combine VFIO and virtio-fs DAX? Maybe not. It
involves pinning host page cache pages O_o.

Stefan

--yZnyZsPjQYjG7xG7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl/OQMUACgkQnKSrs4Gr
c8jT2Af+JXkEPTuSerosjvKJgxGcKudB8C6f/Okm8J3Ylryh+5QznpspkUcnzDUe
DokGkgjxcA6sqSsEMGqwSGLS3Ozshm9sUGRK4GAZsblxWDS9a5Es5A9SQvh117ip
PED58xmoIHuFhoMIkzo/BrBvVzRFX/x4q7VEredEv23pAvlNWIRQm60DsgULcqiU
1EEbA+Hl8w0s4PYEYOw7suFUI3+lDB/0oOd9+YXl9UyV7guC7jaGJg+gQX7mVBi2
fnTlX/JeigsKT/DcwMFmlMtvw0emRYtfIOtubsT/k2eYM+5Az9OTzWqNF+33sJhe
fGup4va8T0HHYPiOwaKu+QrFfwDgHw==
=gJnL
-----END PGP SIGNATURE-----

--yZnyZsPjQYjG7xG7--
