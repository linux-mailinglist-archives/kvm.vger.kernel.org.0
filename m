Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0860E4CD86
	for <lists+kvm@lfdr.de>; Thu, 20 Jun 2019 14:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731758AbfFTMQ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Jun 2019 08:16:27 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38736 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbfFTMQ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Jun 2019 08:16:26 -0400
Received: by mail-wm1-f67.google.com with SMTP id s15so2929582wmj.3
        for <kvm@vger.kernel.org>; Thu, 20 Jun 2019 05:16:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B9TrtGyucT7ajjWuvboh+Hy5dvZksEd6/p4CR2fghIg=;
        b=H8OYnCIip9SDNd3cqvTNVJZ+vobEtjjgsms7xoLyOY1vTnfxNjEP9hQtVv6e8aYY69
         sIefouMSxVEA0BhDYIiDbKN3xyTZEaWS0m+htkXI6bdVJd9I7lxdg+Rhv2ywVyeyWuk+
         zfgyevekIdwpcUWCDWiFUU1A58E4o6f+YAGrfjniD5AZpsmPhEROSmB0vYUkR2zOsfH5
         bHTDrULOubh2joi3DvijKKWIYHwbQbcQdhIFL+lpg+0HF9yawXZ36BdrnKf1f+vM6bu7
         C8FLQ08DbpTiemmfXBfVvpeiwT57p/hwXyY6l67qpE7taRvaxNbEWw0cbUc3WV2Qddoi
         CHFQ==
X-Gm-Message-State: APjAAAW4TKgT+n9l7USUNrtS4NmVuoi0E4o1wAteixUBPdFEqyTa8OLY
        AoqRQSNdjVnSl9j0jFmmddaCqiSw/a4=
X-Google-Smtp-Source: APXvYqzkWL+juoCKmAeAkp5CGN3y2wmBiY61EVn/WFlS6StZw7pwdzH2GmRBNiiSmutGjpGYKskLFA==
X-Received: by 2002:a1c:4484:: with SMTP id r126mr2782080wma.27.1561032984421;
        Thu, 20 Jun 2019 05:16:24 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7822:aa18:a9d8:39ab? ([2001:b07:6468:f312:7822:aa18:a9d8:39ab])
        by smtp.gmail.com with ESMTPSA id d18sm36464286wrb.90.2019.06.20.05.16.23
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 05:16:23 -0700 (PDT)
Subject: Re: [PATCH RFC] kvm: x86: Expose AVX512_BF16 feature to guest
To:     Jing Liu <jing2.liu@linux.intel.com>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jing2.liu@intel.com
References: <1561029712-11848-1-git-send-email-jing2.liu@linux.intel.com>
 <1561029712-11848-2-git-send-email-jing2.liu@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <fd861e94-3ea5-3976-9855-05375f869f00@redhat.com>
Date:   Thu, 20 Jun 2019 14:16:22 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <1561029712-11848-2-git-send-email-jing2.liu@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/06/19 13:21, Jing Liu wrote:
> +		for (i = 1; i <= times; i++) {
> +			if (*nent >= maxnent)
> +				goto out;
> +			do_cpuid_1_ent(&entry[i], function, i);
> +			entry[i].eax &= F(AVX512_BF16);
> +			entry[i].ebx = 0;
> +			entry[i].ecx = 0;
> +			entry[i].edx = 0;
> +			entry[i].flags |= KVM_CPUID_FLAG_SIGNIFCANT_INDEX;
> +			++*nent;

This woud be wrong for i > 1, so instead make this

	if (entry->eax >= 1)

and define F(AVX512_BF16) as a new constant kvm_cpuid_7_1_eax_features.

Paolo
