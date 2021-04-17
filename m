Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF86362FE8
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhDQMlM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 08:41:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55057 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236092AbhDQMlK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 08:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618663244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TqrvZ1Dkru+/UoYpNG8zNQQVDXUCtyWvIhM6uMe/QYE=;
        b=i2d2Tdbk/uZ3Dym2Qx5IoP4KgxN2FcbOBEaPtHkDlKx/LGeao5LKf+N2LkB51nihd72sW5
        FT8BxwiHOlX6TNJaw6z2H+DZ3P+OokfIPArQ/KuA4zzeStiVfyK5q/QJnGqFpIDSXmmgsv
        tp478FhmNsQeMhX3UacWyAnCod1yBP8=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-321-lhvMO4nZMc29R4RKw2nciQ-1; Sat, 17 Apr 2021 08:40:42 -0400
X-MC-Unique: lhvMO4nZMc29R4RKw2nciQ-1
Received: by mail-ed1-f72.google.com with SMTP id z3-20020a05640240c3b029037fb0c2bd3bso8661255edb.23
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 05:40:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TqrvZ1Dkru+/UoYpNG8zNQQVDXUCtyWvIhM6uMe/QYE=;
        b=BSw6Zy3kvtsSDBoIZLDTPlXePhgMdWmDIjS3cVEIi50dTRRhgJ2UkNpiB4FyIsqpcI
         9O76YrCfBTpl96NXsqyikizXleyBGCdha7G7K3zQITn1YiwgiQQnjRqlowCszobkvi4a
         ZeVTKoye3yQApAosaUudw1PaBKe0iaURl2bRKldGptq8TnthD4d6OAZbNuS9y2QPSoSm
         cRCeSpYWsWeikyLcpYiP+JM//9sj1ZfwksZK95HnfHidVFekxYewHXskRpcQPC2Wed19
         NZyxH3RusVws9UAgu6i1IkT4A+XAvMaxGqKtewjhGhVp3Tv9ZLqDorBQ9YQfDWXRBpKw
         94gw==
X-Gm-Message-State: AOAM531/xSrRE14ksi4Wvkd8mUEuXJzji8ZmBEObMvqI+hF6NWKdZ5W9
        I+rHfMNiZ6lisbXzIxKukC0jw/8fOCytMtwARFk7aGwIXC2Tk788Nt32jFwExiOcjyzJcHLHepY
        GKCuVsM96IyyB
X-Received: by 2002:a05:6402:274d:: with SMTP id z13mr15616284edd.344.1618663241198;
        Sat, 17 Apr 2021 05:40:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzuVNotS7UuM5iC6y6t+d4QVfhpv2hpnGhQ/F7RgY/qBafN2qn+UanZL80GrJJH3CQjgbNfA==
X-Received: by 2002:a05:6402:274d:: with SMTP id z13mr15616277edd.344.1618663241058;
        Sat, 17 Apr 2021 05:40:41 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id p4sm7982027edr.43.2021.04.17.05.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 05:40:40 -0700 (PDT)
Subject: Re: [PATCH v2 5/8] crypto: ccp: Use the stack for small SEV command
 buffers
To:     Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Christophe Leroy <christophe.leroy@csgroup.eu>
References: <20210406224952.4177376-1-seanjc@google.com>
 <20210406224952.4177376-6-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <587677cf-2db1-1bed-18fc-dbbc1c1dffed@redhat.com>
Date:   Sat, 17 Apr 2021 14:40:39 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210406224952.4177376-6-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 07/04/21 00:49, Sean Christopherson wrote:
> For commands with small input/output buffers, use the local stack to
> "allocate" the structures used to communicate with the PSP.   Now that
> __sev_do_cmd_locked() gracefully handles vmalloc'd buffers, there's no
> reason to avoid using the stack, e.g. CONFIG_VMAP_STACK=y will just work.
> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Squashing this in (inspired by Christophe's review, though not quite
matching his suggestion).

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 0f5644a3b138..246b281b6376 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -408,12 +408,11 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
  	if (copy_from_user(&input, (void __user *)argp->data, sizeof(input)))
  		return -EFAULT;
  
+	memset(&data, 0, sizeof(data));
+
  	/* userspace wants to query CSR length */
-	if (!input.address || !input.length) {
-		data.address = 0;
-		data.len = 0;
+	if (!input.address || !input.length)
  		goto cmd;
-	}
  
  	/* allocate a physically contiguous buffer to store the CSR blob */
  	input_address = (void __user *)input.address;


