Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B47EE276CF
	for <lists+kvm@lfdr.de>; Thu, 23 May 2019 09:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfEWHVG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 May 2019 03:21:06 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38450 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726222AbfEWHVG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 May 2019 03:21:06 -0400
Received: by mail-pg1-f194.google.com with SMTP id v11so2655993pgl.5
        for <kvm@vger.kernel.org>; Thu, 23 May 2019 00:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ozlabs-ru.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4N8baFm7+zxj0Z7sIKBVPzGK9ryNrkRDZkUqtIXDmLA=;
        b=hOZBVRcj//YbCQL14p30pOCpT685YAIGLDHN0CinekbHqJYxJllDQt5B+YP87aGmn/
         NmNB/KUaEy9QewCY6tBXknHCORiYpzG08QUPpM37BlLvOWT9GME377M2xN4Jf+OGxXMg
         OuqouLe4Z7Sa9iZ1H8SsrQ1w5tNJRSzAimz1Ez16l2LU6BlUCVK6duksToeQt8UW3Keg
         SxnfnrrzXflDYXiAlsqb9Krzfjb1d9iSK/kBdm8hPsG/W9c6Bq0/dPrD+bbIefOZa7DZ
         4qgRyJ0UPSIwzMRKLWREsiiizkjCImswlurO6HaahpcUEMYSUhPK7fpoLUlFZF6PB4qT
         2l9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4N8baFm7+zxj0Z7sIKBVPzGK9ryNrkRDZkUqtIXDmLA=;
        b=FDn2ctKuojjDRTIvwTlcCv3WL8+pjvSpvnDBpNN31djMdKyu2G3PseCm0yy+T5i0cR
         OfbzyC8JgfnGUiEvLcJ6YGV+grKb4CGy/a+XQEhD1J0irtg8UitdN2a8Ixsk0AvHDvGy
         T6vzwqepn8jFfAb1l9E+7Ivv7t4XwXy6OgicOBL87GXu8Z0vbAY1UeI1di8Xquh1gR7f
         NWDWNoV44yO+jxGE8Hyy35mIQ4DrHDEFITFvHwyWX/i8g1Of8HeJhv6drWptjoco12TY
         GBRShJdzJFb13jOoZT6cyEayRnvGslNQn+or6lxl9YuNXY0tXGBd4bX+tL7bcnaOkYds
         BoBQ==
X-Gm-Message-State: APjAAAWKl4g0Klz/BstySYYmfRh140eqggQwcFjxLAjUFfgcPZjKiaGC
        oCKxhNwXG6N20M2V0nFQ3Vbo1g==
X-Google-Smtp-Source: APXvYqy+R3DrOQ5YuoPh8Zt3c+E18gWx3rM25ivuAy5i7iKh6+7nH/A1M7uYeRATvM4jHaKfyPRBbw==
X-Received: by 2002:a63:4820:: with SMTP id v32mr93891322pga.89.1558596064762;
        Thu, 23 May 2019 00:21:04 -0700 (PDT)
Received: from [10.61.2.175] ([122.99.82.10])
        by smtp.gmail.com with ESMTPSA id j14sm16170503pfe.10.2019.05.23.00.21.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 00:21:04 -0700 (PDT)
Subject: Re: [PATCH 0/4] KVM: PPC: Book3S: Fix potential deadlocks
To:     Paul Mackerras <paulus@ozlabs.org>, kvm@vger.kernel.org
Cc:     kvm-ppc@vger.kernel.org,
        =?UTF-8?Q?C=c3=a9dric_Le_Goater?= <clg@kaod.org>
References: <20190523063424.GB19655@blackberry>
From:   Alexey Kardashevskiy <aik@ozlabs.ru>
Openpgp: preference=signencrypt
Autocrypt: addr=aik@ozlabs.ru; keydata=
 mQINBE+rT0sBEADFEI2UtPRsLLvnRf+tI9nA8T91+jDK3NLkqV+2DKHkTGPP5qzDZpRSH6mD
 EePO1JqpVuIow/wGud9xaPA5uvuVgRS1q7RU8otD+7VLDFzPRiRE4Jfr2CW89Ox6BF+q5ZPV
 /pS4v4G9eOrw1v09lEKHB9WtiBVhhxKK1LnUjPEH3ifkOkgW7jFfoYgTdtB3XaXVgYnNPDFo
 PTBYsJy+wr89XfyHr2Ev7BB3Xaf7qICXdBF8MEVY8t/UFsesg4wFWOuzCfqxFmKEaPDZlTuR
 tfLAeVpslNfWCi5ybPlowLx6KJqOsI9R2a9o4qRXWGP7IwiMRAC3iiPyk9cknt8ee6EUIxI6
 t847eFaVKI/6WcxhszI0R6Cj+N4y+1rHfkGWYWupCiHwj9DjILW9iEAncVgQmkNPpUsZECLT
 WQzMuVSxjuXW4nJ6f4OFHqL2dU//qR+BM/eJ0TT3OnfLcPqfucGxubhT7n/CXUxEy+mvWwnm
 s9p4uqVpTfEuzQ0/bE6t7dZdPBua7eYox1AQnk8JQDwC3Rn9kZq2O7u5KuJP5MfludMmQevm
 pHYEMF4vZuIpWcOrrSctJfIIEyhDoDmR34bCXAZfNJ4p4H6TPqPh671uMQV82CfTxTrMhGFq
 8WYU2AH86FrVQfWoH09z1WqhlOm/KZhAV5FndwVjQJs1MRXD8QARAQABtCRBbGV4ZXkgS2Fy
 ZGFzaGV2c2tpeSA8YWlrQG96bGFicy5ydT6JAjgEEwECACIFAk+rT0sCGwMGCwkIBwMCBhUI
 AgkKCwQWAgMBAh4BAheAAAoJEIYTPdgrwSC5fAIP/0wf/oSYaCq9PhO0UP9zLSEz66SSZUf7
 AM9O1rau1lJpT8RoNa0hXFXIVbqPPKPZgorQV8SVmYRLr0oSmPnTiZC82x2dJGOR8x4E01gK
 TanY53J/Z6+CpYykqcIpOlGsytUTBA+AFOpdaFxnJ9a8p2wA586fhCZHVpV7W6EtUPH1SFTQ
 q5xvBmr3KkWGjz1FSLH4FeB70zP6uyuf/B2KPmdlPkyuoafl2UrU8LBADi/efc53PZUAREih
 sm3ch4AxaL4QIWOmlE93S+9nHZSRo9jgGXB1LzAiMRII3/2Leg7O4hBHZ9Nki8/fbDo5///+
 kD4L7UNbSUM/ACWHhd4m1zkzTbyRzvL8NAVQ3rckLOmju7Eu9whiPueGMi5sihy9VQKHmEOx
 OMEhxLRQbzj4ypRLS9a+oxk1BMMu9cd/TccNy0uwx2UUjDQw/cXw2rRWTRCxoKmUsQ+eNWEd
 iYLW6TCfl9CfHlT6A7Zmeqx2DCeFafqEd69DqR9A8W5rx6LQcl0iOlkNqJxxbbW3ddDsLU/Y
 r4cY20++WwOhSNghhtrroP+gouTOIrNE/tvG16jHs8nrYBZuc02nfX1/gd8eguNfVX/ZTHiR
 gHBWe40xBKwBEK2UeqSpeVTohYWGBkcd64naGtK9qHdo1zY1P55lHEc5Uhlk743PgAnOi27Q
 ns5zuQINBE+rT0sBEACnV6GBSm+25ACT+XAE0t6HHAwDy+UKfPNaQBNTTt31GIk5aXb2Kl/p
 AgwZhQFEjZwDbl9D/f2GtmUHWKcCmWsYd5M/6Ljnbp0Ti5/xi6FyfqnO+G/wD2VhGcKBId1X
 Em/B5y1kZVbzcGVjgD3HiRTqE63UPld45bgK2XVbi2+x8lFvzuFq56E3ZsJZ+WrXpArQXib2
 hzNFwQleq/KLBDOqTT7H+NpjPFR09Qzfa7wIU6pMNF2uFg5ihb+KatxgRDHg70+BzQfa6PPA
 o1xioKXW1eHeRGMmULM0Eweuvpc7/STD3K7EJ5bBq8svoXKuRxoWRkAp9Ll65KTUXgfS+c0x
 gkzJAn8aTG0z/oEJCKPJ08CtYQ5j7AgWJBIqG+PpYrEkhjzSn+DZ5Yl8r+JnZ2cJlYsUHAB9
 jwBnWmLCR3gfop65q84zLXRQKWkASRhBp4JK3IS2Zz7Nd/Sqsowwh8x+3/IUxVEIMaVoUaxk
 Wt8kx40h3VrnLTFRQwQChm/TBtXqVFIuv7/Mhvvcq11xnzKjm2FCnTvCh6T2wJw3de6kYjCO
 7wsaQ2y3i1Gkad45S0hzag/AuhQJbieowKecuI7WSeV8AOFVHmgfhKti8t4Ff758Z0tw5Fpc
 BFDngh6Lty9yR/fKrbkkp6ux1gJ2QncwK1v5kFks82Cgj+DSXK6GUQARAQABiQIfBBgBAgAJ
 BQJPq09LAhsMAAoJEIYTPdgrwSC5NYEP/2DmcEa7K9A+BT2+G5GXaaiFa098DeDrnjmRvumJ
 BhA1UdZRdfqICBADmKHlJjj2xYo387sZpS6ABbhrFxM6s37g/pGPvFUFn49C47SqkoGcbeDz
 Ha7JHyYUC+Tz1dpB8EQDh5xHMXj7t59mRDgsZ2uVBKtXj2ZkbizSHlyoeCfs1gZKQgQE8Ffc
 F8eWKoqAQtn3j4nE3RXbxzTJJfExjFB53vy2wV48fUBdyoXKwE85fiPglQ8bU++0XdOr9oyy
 j1llZlB9t3tKVv401JAdX8EN0++ETiOovQdzE1m+6ioDCtKEx84ObZJM0yGSEGEanrWjiwsa
 nzeK0pJQM9EwoEYi8TBGhHC9ksaAAQipSH7F2OHSYIlYtd91QoiemgclZcSgrxKSJhyFhmLr
 QEiEILTKn/pqJfhHU/7R7UtlDAmFMUp7ByywB4JLcyD10lTmrEJ0iyRRTVfDrfVP82aMBXgF
 tKQaCxcmLCaEtrSrYGzd1sSPwJne9ssfq0SE/LM1J7VdCjm6OWV33SwKrfd6rOtvOzgadrG6
 3bgUVBw+bsXhWDd8tvuCXmdY4bnUblxF2B6GOwSY43v6suugBttIyW5Bl2tXSTwP+zQisOJo
 +dpVG2pRr39h+buHB3NY83NEPXm1kUOhduJUA17XUY6QQCAaN4sdwPqHq938S3EmtVhsuQIN
 BFq54uIBEACtPWrRdrvqfwQF+KMieDAMGdWKGSYSfoEGGJ+iNR8v255IyCMkty+yaHafvzpl
 PFtBQ/D7Fjv+PoHdFq1BnNTk8u2ngfbre9wd9MvTDsyP/TmpF0wyyTXhhtYvE267Av4X/BQT
 lT9IXKyAf1fP4BGYdTNgQZmAjrRsVUW0j6gFDrN0rq2J9emkGIPvt9rQt6xGzrd6aXonbg5V
 j6Uac1F42ESOZkIh5cN6cgnGdqAQb8CgLK92Yc8eiCVCH3cGowtzQ2m6U32qf30cBWmzfSH0
 HeYmTP9+5L8qSTA9s3z0228vlaY0cFGcXjdodBeVbhqQYseMF9FXiEyRs28uHAJEyvVZwI49
 CnAgVV/n1eZa5qOBpBL+ZSURm8Ii0vgfvGSijPGbvc32UAeAmBWISm7QOmc6sWa1tobCiVmY
 SNzj5MCNk8z4cddoKIc7Wt197+X/X5JPUF5nQRvg3SEHvfjkS4uEst9GwQBpsbQYH9MYWq2P
 PdxZ+xQE6v7cNB/pGGyXqKjYCm6v70JOzJFmheuUq0Ljnfhfs15DmZaLCGSMC0Amr+rtefpA
 y9FO5KaARgdhVjP2svc1F9KmTUGinSfuFm3quadGcQbJw+lJNYIfM7PMS9fftq6vCUBoGu3L
 j4xlgA/uQl/LPneu9mcvit8JqcWGS3fO+YeagUOon1TRqQARAQABiQRsBBgBCAAgFiEEZSrP
 ibrORRTHQ99dhhM92CvBILkFAlq54uICGwICQAkQhhM92CvBILnBdCAEGQEIAB0WIQQIhvWx
 rCU+BGX+nH3N7sq0YorTbQUCWrni4gAKCRDN7sq0YorTbVVSD/9V1xkVFyUCZfWlRuryBRZm
 S4GVaNtiV2nfUfcThQBfF0sSW/aFkLP6y+35wlOGJE65Riw1C2Ca9WQYk0xKvcZrmuYkK3DZ
 0M9/Ikkj5/2v0vxz5Z5w/9+IaCrnk7pTnHZuZqOh23NeVZGBls/IDIvvLEjpD5UYicH0wxv+
 X6cl1RoP2Kiyvenf0cS73O22qSEw0Qb9SId8wh0+ClWet2E7hkjWFkQfgJ3hujR/JtwDT/8h
 3oCZFR0KuMPHRDsCepaqb/k7VSGTLBjVDOmr6/C9FHSjq0WrVB9LGOkdnr/xcISDZcMIpbRm
 EkIQ91LkT/HYIImL33ynPB0SmA+1TyMgOMZ4bakFCEn1vxB8Ir8qx5O0lHMOiWMJAp/PAZB2
 r4XSSHNlXUaWUg1w3SG2CQKMFX7vzA31ZeEiWO8tj/c2ZjQmYjTLlfDK04WpOy1vTeP45LG2
 wwtMA1pKvQ9UdbYbovz92oyZXHq81+k5Fj/YA1y2PI4MdHO4QobzgREoPGDkn6QlbJUBf4To
 pEbIGgW5LRPLuFlOPWHmIS/sdXDrllPc29aX2P7zdD/ivHABslHmt7vN3QY+hG0xgsCO1JG5
 pLORF2N5XpM95zxkZqvYfC5tS/qhKyMcn1kC0fcRySVVeR3tUkU8/caCqxOqeMe2B6yTiU1P
 aNDq25qYFLeYxg67D/4w/P6BvNxNxk8hx6oQ10TOlnmeWp1q0cuutccblU3ryRFLDJSngTEu
 ZgnOt5dUFuOZxmMkqXGPHP1iOb+YDznHmC0FYZFG2KAc9pO0WuO7uT70lL6larTQrEneTDxQ
 CMQLP3qAJ/2aBH6SzHIQ7sfbsxy/63jAiHiT3cOaxAKsWkoV2HQpnmPOJ9u02TPjYmdpeIfa
 X2tXyeBixa3i/6dWJ4nIp3vGQicQkut1YBwR7dJq67/FCV3Mlj94jI0myHT5PIrCS2S8LtWX
 ikTJSxWUKmh7OP5mrqhwNe0ezgGiWxxvyNwThOHc5JvpzJLd32VDFilbxgu4Hhnf6LcgZJ2c
 Zd44XWqUu7FzVOYaSgIvTP0hNrBYm/E6M7yrLbs3JY74fGzPWGRbBUHTZXQEqQnZglXaVB5V
 ZhSFtHopZnBSCUSNDbB+QGy4B/E++Bb02IBTGl/JxmOwG+kZUnymsPvTtnNIeTLHxN/H/ae0
 c7E5M+/NpslPCmYnDjs5qg0/3ihh6XuOGggZQOqrYPC3PnsNs3NxirwOkVPQgO6mXxpuifvJ
 DG9EMkK8IBXnLulqVk54kf7fE0jT/d8RTtJIA92GzsgdK2rpT1MBKKVffjRFGwN7nQVOzi4T
 XrB5p+6ML7Bd84xOEGsj/vdaXmz1esuH7BOZAGEZfLRCHJ0GVCSssg==
Message-ID: <3d159268-3645-bbf0-8f99-306c9ca68611@ozlabs.ru>
Date:   Thu, 23 May 2019 17:21:00 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190523063424.GB19655@blackberry>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 23/05/2019 16:34, Paul Mackerras wrote:
> Recent reports of lockdep splats in the HV KVM code revealed that it
> was taking the kvm->lock mutex in several contexts where a vcpu mutex
> was already held.  Lockdep has only started warning since I added code
> to take the vcpu mutexes in the XIVE device release functions, but
> since Documentation/virtual/kvm/locking.txt specifies that the vcpu
> mutexes nest inside kvm->lock, it seems that the new code is correct
> and it is most of the old uses of kvm->lock that are wrong.
> 
> This series should fix the problems, by adding new mutexes that nest
> inside the vcpu mutexes and using them instead of kvm->lock.


I applied these 4, compiled, installed, rebooted, tried running a guest
(which failed because I also updated QEMU and its cli has changed), got
this. So VM was created and then destroyed without executing a single
instruction, if that matters.


systemd-journald[1278]: Successfully sent stream file descriptor to
service manager.
systemd-journald[1278]: Successfully sent stream file descriptor to
service manager.
WARNING: CPU: 3 PID: 7697 at arch/powerpc/kvm/book3s_rtas.c:285
kvmppc_rtas_tokens_free+0x100/0x108
[kvm]

Modules linked in: bridge stp llc kvm_hv kvm rpcrdma ib_iser ib_srp
rdma_ucm ib_umad sunrpc rdma_cm
ib_ipoib iw_cm libiscsi ib_cm scsi_transport_iscsi mlx5_ib ib_uverbs
ib_core vmx_crypto crct10dif_vp
msum crct10dif_common at24 sg xfs libcrc32c crc32c_vpmsum mlx5_core
mlxfw autofs4
CPU: 3 PID: 7697 Comm: qemu-kvm Not tainted
5.2.0-rc1-le_nv2_aikATfstn1-p1 #496
NIP:  c00800000f3ab678 LR: c00800000f3ab66c CTR: c000000000198210

REGS: c000003fdf873680 TRAP: 0700   Not tainted
(5.2.0-rc1-le_nv2_aikATfstn1-p1)
MSR:  900000000282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,DR,RI,LE>  CR:
24008882  XER: 20040000
CFAR: c000000000198364 IRQMASK: 0

GPR00: c00800000f3ab66c c000003fdf873910 c00800000f3d8f00
0000000000000000
GPR04: c000003f4c984630 0000000000000000 00000000d5952dee
0000000000000000
GPR08: 0000000000000000 0000000000000000 0000000000000000
c00800000f3b95c0
GPR12: c000000000198210 c000003fffffbb80 00007ffff20d57a8
0000000000000000
GPR16: 0000000000000000 0000000000000008 0000000119dcd0c0
0000000000000001
GPR20: c000003f4c98f530 c000003f4c980098 c000003f4c984188
0000000000000000
GPR24: c000003f4c98a740 0000000000000000 c000003fdf8dd200
c00800000f3d1c18
GPR28: c000003f4c98a858 c000003f4c980000 c000003f4c9840c8
c000003f4c980000
NIP [c00800000f3ab678] kvmppc_rtas_tokens_free+0x100/0x108 [kvm]

LR [c00800000f3ab66c] kvmppc_rtas_tokens_free+0xf4/0x108 [kvm]

Call Trace:

[c000003fdf873910] [c00800000f3ab66c] kvmppc_rtas_tokens_free+0xf4/0x108
[kvm] (unreliable)
[c000003fdf873960] [c00800000f3aa640] kvmppc_core_destroy_vm+0x48/0xa8
[kvm]
[c000003fdf873990] [c00800000f3a4b08] kvm_arch_destroy_vm+0x130/0x190
[kvm]
[c000003fdf8739d0] [c00800000f3985dc] kvm_put_kvm+0x204/0x500 [kvm]

[c000003fdf873a60] [c00800000f398910] kvm_vm_release+0x38/0x60 [kvm]

[c000003fdf873a90] [c0000000004345fc] __fput+0xcc/0x2f0

[c000003fdf873af0] [c000000000139318] task_work_run+0x108/0x150

[c000003fdf873b30] [c000000000109408] do_exit+0x438/0xe10

[c000003fdf873c00] [c000000000109eb0] do_group_exit+0x60/0xe0

[c000003fdf873c40] [c00000000011ea24] get_signal+0x1b4/0xce0

[c000003fdf873d30] [c000000000025ea8] do_notify_resume+0x1a8/0x430

[c000003fdf873e20] [c00000000000e444] ret_from_except_lite+0x70/0x74

Instruction dump:

ebc1fff0 ebe1fff8 7c0803a6 4e800020 60000000 60000000 3880ffff 38634630

4800df59 e8410018 2fa30000 409eff44 <0fe00000> 4bffff3c 7c0802a6
60000000
irq event stamp: 114938

hardirqs last  enabled at (114937): [<c0000000003ab8f4>]
free_unref_page+0xd4/0x100
hardirqs last disabled at (114938): [<c000000000009060>]
program_check_common+0x170/0x180
softirqs last  enabled at (114424): [<c000000000a06bdc>]
peernet2id+0x6c/0xb0
softirqs last disabled at (114422): [<c000000000a06bb4>]
peernet2id+0x44/0xb0
---[ end trace c33c9599a1a73dd2 ]---

systemd-journald[1278]: Compressed data object 650 -> 280 using XZ

tun: Universal TUN/TAP device driver, 1.6

virbr0: port 1(virbr0-nic) entered blocking state





-- 
Alexey
