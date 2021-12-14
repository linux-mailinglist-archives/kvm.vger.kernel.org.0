Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3624474058
	for <lists+kvm@lfdr.de>; Tue, 14 Dec 2021 11:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233018AbhLNKWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 05:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233009AbhLNKVz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 05:21:55 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5FCC061748;
        Tue, 14 Dec 2021 02:21:54 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y13so60875947edd.13;
        Tue, 14 Dec 2021 02:21:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vqmhwUy6GadRfVqeD4wMYlbNTxSvdhpRcyq0d4RGLhc=;
        b=QijeLAsqvfPBvXe5C5KRuNLZ9v0rp8MiJ/mpfLUw2cz6mor/RpTqSmWKp3Okj8cByN
         tRFRmNr0sXytPi+UfJOvIQYMhGCeYDbIHzeJolhYhvJtBpgqK1m3p75sBCEDAQr2bI91
         0+ZtHFw3ra7FB+bGA1eVoMs3EF4eEbcMgI6OaSDieAK87xH+lvxPo8oARkHlc45Nxbc0
         NzTkw7IgqLHrBMjP4j+D2WXBNzYH3yuRCz3bFlaMr5OG05IwnrShsxc+k6HgT9shJwmN
         DTWDkRNCgXxmKSPewd96H5r8zAPgJ1UcRiT3sjVDN3Gs9KYJAsKsWeUeD6qN2AG6Ah9G
         oblQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vqmhwUy6GadRfVqeD4wMYlbNTxSvdhpRcyq0d4RGLhc=;
        b=1gzimry8J6mQdI50ZtDso+inc3wdl2+acFVliq2shN2JoAq3kVLDGQrIdxnf98wULA
         cnjO5lVjNZu+vnB3oFM7vhhq4dYccqVFNfn5jpnefiIU5agfmlpTaEb7NXfg5ZnzSka1
         rxCHSjz/adZJFIXKQbMzjnaj/rpWfIMKc41pzJzF4UZYn9+uOVMPGEcg28hfHjgY/cKQ
         XDbdwcAJS1CT+kVLFDPOicCGBEEZbOwwYt5Ht2JxSPMwqf9MIxdtIxgTotrjMKrFgIxJ
         djXUxl7Swnq8A3JfFwBPoqzSk5Foma1GvJUNBwrkvHTNTVoDOXs7wa/YGjVACmd/odvp
         VX6g==
X-Gm-Message-State: AOAM531T81D+SSq+ne5sxjIiy8AzxMZsgJXVSDWaYNSt2xCzm4x0pmgz
        TSCC9ob+HUco/14j6lv1+p0=
X-Google-Smtp-Source: ABdhPJxBjTnEDEk5cjw/VGjh65z+t5dY683AVJ/MeC7qioJeXdcXZn3+JHv1DsiO6d4p2fPuZa2OBg==
X-Received: by 2002:a05:6402:147:: with SMTP id s7mr6704777edu.8.1639477313263;
        Tue, 14 Dec 2021 02:21:53 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id ch28sm7488899edb.72.2021.12.14.02.21.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Dec 2021 02:21:52 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f49f9358-a903-3ee1-46f8-1662911390ef@redhat.com>
Date:   Tue, 14 Dec 2021 11:21:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [patch 4/6] x86/fpu: Add guest support to xfd_enable_feature()
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Jing Liu <jing2.liu@linux.intel.com>,
        "Zhong, Yang" <yang.zhong@intel.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Nakajima, Jun" <jun.nakajima@intel.com>
References: <20211214022825.563892248@linutronix.de>
 <20211214024947.991506193@linutronix.de>
 <BN9PR11MB5276D76F3F0729865FCE02938C759@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <BN9PR11MB5276D76F3F0729865FCE02938C759@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/14/21 07:05, Tian, Kevin wrote:
>> +	if (guest_fpu) {
>> +		newfps->is_guest = true;
>> +		newfps->is_confidential = curfps->is_confidential;
>> +		newfps->in_use = curfps->in_use;
>> +		guest_fpu->xfeatures |= xfeatures;
>> +	}
>> +
> As you explained guest fpstate is not current active in the restoring
> path, thus it's not correct to always inherit attributes from the
> active one.

Indeed, guest_fpu->fpstate should be used instead of curfps.

Paolo
