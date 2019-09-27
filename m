Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0D13BFD3C
	for <lists+kvm@lfdr.de>; Fri, 27 Sep 2019 04:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728754AbfI0Cjj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Sep 2019 22:39:39 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:36467 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728656AbfI0Cji (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Sep 2019 22:39:38 -0400
Received: by mail-pl1-f196.google.com with SMTP id f19so455022plr.3
        for <kvm@vger.kernel.org>; Thu, 26 Sep 2019 19:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ekkVN8vNhuwBOppq3UunfHvXp65AzDqzg16gW/0egm4=;
        b=jBc0voXismu32pO2BO8jhA3kP6wvG4Dep9PluZdWEtvYTvTjtK0DgIQg4nfrgne2Ys
         mTZwYRW492bwtAOzfqrXgUGlKX4sjQ6mb3l3XXwUyglLuAkMxCUjP8YZwz9iMsP8zdbC
         fA5QDdEse/a+B29GNdPzfvEGfX+oEun3890uLQFl+9epyDFNEbNkXjxRCRtEEF5oUVQI
         kM/a1zavhJmfwV69p0cNu7L9pVsqePcuh1L8PTYVuPRfe2/JeXWw9Lo2S/oy4MpUqqJj
         ENmdw9cnMBUnbDTRs5H9uatiOxsy4ryJrJjiRyYUdML+OrbbhU5lukDPIz0NUQ2iLOuO
         7uyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=ekkVN8vNhuwBOppq3UunfHvXp65AzDqzg16gW/0egm4=;
        b=Ig/DCwyZZFWMCN2gHjkeV2C4hoJEoAIhfegzS8Mnv3/oaoVkA9jCefzJR5wrFA6Nlu
         9OjNubkzs021C5Ysf8dhradrI6bSeD1+DJuymzMyajOkMtdBIEUxbxdBsbBatWkvCgC7
         srPC9Xbx0a8R4fqt6KkEh8sq9X7JY4ypgNM73gp6WAjrQsI0FO0HUt50RZmtUDvQ8zqk
         5zeX3Ofny/2l+jyVQNJmXRS2hLngVmJMddAcNBTo81u5AWYMbfLFPUvcTdWOVDwHmH2K
         ucvMS7RoyCqbIn7nR4SEJLNxdyPJaBYmu15p6q8xWB16KsLqVl5HMBfh671oam84/+vQ
         ePAw==
X-Gm-Message-State: APjAAAX7FFFCtwXsGWmwADYycBCCuZ3PQJ7RqZ4w6v4wXK2RhOjgBaS1
        rdjzyKaj/vW4kvmmuKXN9lyNHg==
X-Google-Smtp-Source: APXvYqz9YGl0y5Pfo2hmrpMviBp5e9aOQupBM21T2Mw4S1HNb/iO6gxYMd6jPC40h+6suhv6nexJ9Q==
X-Received: by 2002:a17:902:7203:: with SMTP id ba3mr1922118plb.51.1569551976166;
        Thu, 26 Sep 2019 19:39:36 -0700 (PDT)
Received: from js-desktop.svl.corp.google.com ([2620:15c:2cd:2:5e41:bb1f:98fb:39da])
        by smtp.gmail.com with ESMTPSA id l27sm619645pgc.53.2019.09.26.19.39.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Sep 2019 19:39:35 -0700 (PDT)
Subject: Re: [PATCH 2/3] KVM: x86: fix nested guest live migration with PML
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <1569518306-46567-1-git-send-email-pbonzini@redhat.com>
 <1569518306-46567-3-git-send-email-pbonzini@redhat.com>
From:   Junaid Shahid <junaids@google.com>
Openpgp: preference=signencrypt
Autocrypt: addr=junaids@google.com; keydata=
 mQGNBFyBfSUBDADJpxqPVaO+D+pK2zarR0QwxUAAA7kVV9uPO5iEJXWAmZJJSzeRSoZEEcVg
 hXXQzmYaEn18kA/lDih1/20gr7y0sCupvQwnE0itvLYqyPzmWv93ilkOXnus7CySH2CDINH7
 49+kHhA5YX1TxWBYoAbKxyc/IKHG7h/hsSxCfQhYZimE1hpZUcVx77GD6h2Fbh855c2p8RN8
 D/A+fMkBncrpRgWjpc64bLrZnLGJz+/BB301xA2xhMrllGpgreW6ZmiUEh1/oTWMnEUzADx5
 bzDRSZyw4fUlysAOujmHmJ4B6ORIhYZkyReo2wdHXizsv2lonifygsM8yfBSAOEBez3yDoic
 Yb9qIZoVNlBGFuHJrp4sx41JxFr9EOeHQtbX8O3iy+n8afrBlVPMZiUkEtnsat+LsT5ix2Nk
 mdeY9J5zBwalKEC5zCZ1OfSo9rBLF+pamT/EeCGzatNFY7pyqcOjGvFxloYEKn+D8P0DYFRP
 ny7CeVwLZo43nkaiyRKMeHcAEQEAAbQiSnVuYWlkIFNoYWhpZCA8anVuYWlkc0Bnb29nbGUu
 Y29tPokB1AQTAQoAPhYhBK06Mjqf2kfFM5QUJZzM5LZ0wQJuBQJcgX0lAhsDBQkDwmcABQsJ
 CAcCBhUKCQgLAgQWAgMBAh4BAheAAAoJEJzM5LZ0wQJuwcwMAIKabL0Uv5uk7u6ti+HXf85U
 AFGauxVOWoJHMpK0I2FwuokaumOZDOjAmYvMc9vka6W9CrR0A1LbxIJofFiG8K2cGPxAVWp1
 ozihfXJ4FJneCime741VCdNTlAa5nE7RAppGMuQHjrDI8+oRO5je28UVc8y+neHvgqk3Q1WA
 PbRDTWlnEcdas9GjCMHKb760NLIterenSuuNKIiJraUyA22Hx4F+xIfX7h3tyDnd4x5HGRNg
 Vkji+usAwYSQi9RrVLG2tWKq+Jn2KzmplmmpALsTyMNYWJG7bi7Ler7tNgCpvVcrBjj5Ggo+
 ELmhY56b9EjFT8NjA0vJWT97ulfte9swDpOGxPvACXeRJ+zj+XI9IXet9m6Nj5Jwg9ZROHv7
 FKaupIO0BViiqkuH1je8TQTNbuDaFibvOL5kX90a1ksNKt1kPVfG+oEhhfhDGYHe6corVTkG
 8jyQMogT8fdKxk4BcmHntZKVJgAgD0wlwD1jxWxiANFu0VMVcw/1H81uYrkBjQRcgX0lAQwA
 yYPd+RNEuoUG87by+P8pkbFdATn5Iw9eHE88j9XCTb+kZeckiun3doWKH4FWcD7hDooDBGH2
 lhzx9Qv+cqga4y+lHAONHJRkska/RTf7TLG/363rb/HCHPBOY8FihN57Pewb3ozhtYF/p9/a
 O+hs0NEnqs/lmw1eULp9EuwpyhmbLnWARCG1aviMIGhnB7re7B4i0+VNrMjqVSDPX+iMVy7c
 QJb1T0DtxKjLIg8vZBBaQO/k6R/7Pvuy7Ld0j1MIwDGWZqL4sNiZE8MFgbYq3E7C5lCEtm/5
 GMI4MVppbk/s18yI+HAyHq75bTw1Vh9RKz5RD2Or3UDPrLwjrSEe7+Aw73GY/9MEdmlllcvh
 6TVkYyo2melaffi7aZnfqtRK9n0eF5bdfwo/dU7G89CxSbkMofeobHXobMSJCETVCzkIFjjn
 EBUguMYLhtsxK7NjypX8eYM46wuxVRgHqV6Sf/hYoJkcBa7jJf0epr/dGZHSYF9uq4qIX5ww
 fNqabsu3ABEBAAGJAbwEGAEKACYWIQStOjI6n9pHxTOUFCWczOS2dMECbgUCXIF9JQIbDAUJ
 A8JnAAAKCRCczOS2dMECbt8hC/0QoPTA6kfuCMoKq9uT7sRdM7Zx+y8ug0J63HjhsdEfXoMx
 88qXOG/rRrh99uxgqtr5NgtD3kftAtUcBglhgwJxLwo/WLmCFn/zBTZA4klTLgYqRrDtQvev
 bhzXMcSlBsZWiWPaLpSN6CBxWdxSlMWDwnZhfKMwQhg16tk7sxV/vfHU60ZoeIqKfHV83qg5
 nEbeUprl/vwWv3b7d4PgKCLPEhjPFU/6oWuD4cgrsPNp8xqVZ7BXHpWH0hXcIMV2H3+zV4vj
 dJcBMt0VfEgATMVj6fSTZlh3lRceC/OXza2q0qg2HIT9yxErYIL8YSAFikZPJjkG1Wwv9CTd
 s2WSlTd3YfM2EGcJFP1XFZQKl+vs1Jop+rFjynQB2jX0GP1IG4ab1NYHAVX9ENhIiE97gMLL
 5X/clE5ZjNHVh8p8Ivv4UyZk2pfJxBgg9++M3EXfVuZpP4Rzna4ttKLdB5Ehv7YuGHu8E0n9
 iWogGkOc4UGfcj87Lt9ivHEsVoo/lwCTIiQ=
Organization: Google
Message-ID: <f04f7517-67d9-856b-58e4-f3efdc4566d7@google.com>
Date:   Thu, 26 Sep 2019 19:39:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1569518306-46567-3-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/19 10:18 AM, Paolo Bonzini wrote:
> @@ -1597,8 +1615,11 @@ static bool spte_clear_dirty(u64 *sptep)
>  
>  	rmap_printk("rmap_clear_dirty: spte %p %llx\n", sptep, *sptep);
>  
> -	spte &= ~shadow_dirty_mask;
> +	WARN_ON(!spte_ad_enabled(spte));
> +	if (spte_ad_need_write_protect(spte))
> +		return spte_write_protect(sptep, false);
>  
> +	spte &= ~shadow_dirty_mask;
>  	return mmu_spte_update(sptep, spte);
>  }
>  

I think that it would be a bit cleaner to move the spte_ad_need_write_protect() check to the if statement inside __rmap_clear_dirty() instead, since it already checks for spte_ad_enabled() to decide between write-protection and dirty-clearing.


Reviewed-by: Junaid Shahid <junaids@google.com>
