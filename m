Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2AC8132373
	for <lists+kvm@lfdr.de>; Tue,  7 Jan 2020 11:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727784AbgAGKVz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jan 2020 05:21:55 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28089 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726565AbgAGKVy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jan 2020 05:21:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578392514;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wp1B0oryBnzMjpq12qEWIWdEYq7gqXTvQXjEcGcPRhM=;
        b=E6NGFTvM7m5btSb6ZUnT+4W7JUq/vZjnPCymzssu5wpJIv0+xz34QgbgSDsd6QER+44iON
        xefDEQECEsqkTITI22ckx8HpvnjRsxfuH2ZKGZEYioZj84n7VRDtJjEZPDS54TDLvb87DR
        Pz1kTvyUlJUDMuMvDlF5tkvjZOOrOXo=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-D94zc08_MOanOaAliXD6pQ-1; Tue, 07 Jan 2020 05:21:51 -0500
X-MC-Unique: D94zc08_MOanOaAliXD6pQ-1
Received: by mail-wr1-f70.google.com with SMTP id f15so14161601wrr.2
        for <kvm@vger.kernel.org>; Tue, 07 Jan 2020 02:21:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wp1B0oryBnzMjpq12qEWIWdEYq7gqXTvQXjEcGcPRhM=;
        b=ExsJJi6Xq4VBL2FVbeDt7RbGg6Z8Id2OxV07F3NsiK6jTtVoUAw/bIiPWSC+HwHq5K
         qCnUYvcVmKM6DP7RAzZYi5HbQGVPKsEq2Mrn9qlA8pUYO0lv1dpnpk/XzyLVdGrMSoYp
         YYdkW349FZfQGFfLWj24BC+hZRv7BWCrImAvPey12tQKIceY6WEs3E3ZiGPbD7BeSgxp
         6XBJYZBhGsXpq5MiO26vG+IG3Tunbp/sSc2+GhgGZ/Wi3YXf2fT4l28FMY5gXQG3ex1S
         95HzaM53X6lnZq81KYgvtPQb1vsc7dF9F3ZsubXsv1G9Fc+fnfDq5NgNB5k9cpkH0dyS
         bZaw==
X-Gm-Message-State: APjAAAVrr29ZaFCgaWrV622UUuSj+zXix2sd98RaeCqAJORFixNtMyK0
        Ghi54pc/WNI6o80qmq3PqxK5sgJbfwpmna3HZrqY+Fjcp+XCjjEu+Xhc7o6vG4ia4QwV/MfOaVp
        xv5ZqVvOenim0
X-Received: by 2002:a1c:4454:: with SMTP id r81mr38567198wma.117.1578392510127;
        Tue, 07 Jan 2020 02:21:50 -0800 (PST)
X-Google-Smtp-Source: APXvYqzx7uwkQ39Sba+ZHZ4NO0/8s8bU3zLgUXwYFecjdGGaOLjxxil5G4HRAuahmoDCFBepsAAtOA==
X-Received: by 2002:a1c:4454:: with SMTP id r81mr38567170wma.117.1578392509933;
        Tue, 07 Jan 2020 02:21:49 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c6d:4079:b74c:e329? ([2001:b07:6468:f312:c6d:4079:b74c:e329])
        by smtp.gmail.com with ESMTPSA id d16sm81431405wrg.27.2020.01.07.02.21.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 02:21:49 -0800 (PST)
Subject: Re: [PATCH 2/2] drm/i915/gvt: subsitute kvm_read/write_guest with
 vfio_iova_rw
To:     Yan Zhao <yan.y.zhao@intel.com>, zhenyuw@linux.intel.com
Cc:     alex.williamson@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-gvt@eclists.intel.com,
        kevin.tian@intel.com
References: <20200103010055.4140-1-yan.y.zhao@intel.com>
 <20200103010349.4262-1-yan.y.zhao@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <5838d595-ba77-5506-4f2a-d555681a9cc5@redhat.com>
Date:   Tue, 7 Jan 2020 11:21:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200103010349.4262-1-yan.y.zhao@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 03/01/20 02:03, Yan Zhao wrote:
> +	ret = write ? vfio_iova_rw(dev, gpa, buf, len, true) :
> +			vfio_iova_rw(dev, gpa, buf, len, false);
>  
>  	return ret;

"Write" can be just the final argument to vfio_iova_rw, that is

   return vfio_iova_rw(dev, gpa, buf, len, write):

Thanks,

Paolo

