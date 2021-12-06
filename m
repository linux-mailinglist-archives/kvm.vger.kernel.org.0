Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDBF46A1AB
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 17:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234180AbhLFQsq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 11:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235226AbhLFQsm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 11:48:42 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA20C061D5E;
        Mon,  6 Dec 2021 08:45:13 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id v11so23678403wrw.10;
        Mon, 06 Dec 2021 08:45:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Bq1uoLyEN6iN2zraLBXwCa/8ekER6WWg8xJE8D5WbEs=;
        b=XdXEXoiwyJU4wpKTggx91Qvy+Stv4cSIUrHebyWdKyVJSITMEmHqkvZvb8inf7ofYl
         DgMv1GANP3mXwUOOkWRoDxeOVR2fvqlorjiJhGRhW2fum/tB34mpQf1uUFVV9rkqWjqX
         bsgDtYThZFTzBMDLKf6lGcV20nGqYpHrpxUYlVM6ibR6j5w4R86g2TFyw2srFWoM7d4w
         4ZcITHc8i07aHi5UvFfox4Mf6vkRlrUh0xJ+auYoEXEBNqeils8F0+fMV+dctMcs+S/O
         hpfAw6thWRB6T3zYUprSOSHxmu280sDLQjls3By+RKYE5PFg4D9DR4nDTcIi7xjjKn5V
         qTDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Bq1uoLyEN6iN2zraLBXwCa/8ekER6WWg8xJE8D5WbEs=;
        b=PSTbgkk/x33rOkMaMoI/nNzPd9Xm9/Oxdtt2TCemlg3xph56bx/uswq0mSo0oR6xQF
         E7u06ZDYfwMSCZ92GJdTY9EgsfRmvtANSX10dmB+Nfw5CFdoHfdiXk4E6viId6N/t7rT
         mw3qQjDcKY5jOPOnYHHS9DqaoX+H98EVmZmQSUj47JQ3G5gJc73YG4TfH7K3avL5VGvU
         Tg4ygU6apPPKV5fVpsm49TmIRcQMVxZkU8BvF1Y/9eQatr4zWzk1+QvA9jYxY2CTwstw
         ZonpwBEDnUZxAruw+16RphOdjB2kW3wd/0KT9yNIJIMhOjQ//EzRVjltRc9VSekn+MKd
         eq3g==
X-Gm-Message-State: AOAM532BMZ7JUoHrXdPlwqirjKFfufB1zui+OEEpor6hob8GzAwI7A2W
        pOfcT3yhScSU4upNUeNYym4=
X-Google-Smtp-Source: ABdhPJwu3lNPEn4nMyJhanMvdvMxS0bHunBMaFW/HqTwUq4Mkhc5IB4qfjXRpB2bj1u7QosyRSaiMQ==
X-Received: by 2002:a05:6000:1a88:: with SMTP id f8mr44273524wry.54.1638809111781;
        Mon, 06 Dec 2021 08:45:11 -0800 (PST)
Received: from localhost.localdomain ([39.48.147.147])
        by smtp.gmail.com with ESMTPSA id h27sm15445826wmc.43.2021.12.06.08.45.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 08:45:11 -0800 (PST)
From:   Ameer Hamza <amhamza.mgc@gmail.com>
To:     vkuznets@redhat.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        pbonzini@redhat.com, seanjc@google.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, Ameer Hamza <amhamza.mgc@gmail.com>
Subject: [PATCH v3] KVM: x86: fix for missing initialization of return status variable
Date:   Mon,  6 Dec 2021 21:45:03 +0500
Message-Id: <20211206164503.135917-1-amhamza.mgc@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206160813.GA37599@hamza-OptiPlex-7040>
References: <20211206160813.GA37599@hamza-OptiPlex-7040>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

If undefined ioctl number is passed to the kvm_vcpu_ioctl_device_attr
ioctl, we should trigger KVM_BUG_ON() and return with EIO to silent
coverity warning.

Addresses-Coverity: 1494124 ("Uninitialized scalar variable")
Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
---
Changes in v3:
Added KVM_BUG_ON() as default case and returned -EIO
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index e0aa4dd53c7f..b37068f847ff 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -5019,6 +5019,9 @@ static int kvm_vcpu_ioctl_device_attr(struct kvm_vcpu *vcpu,
 	case KVM_SET_DEVICE_ATTR:
 		r = kvm_arch_tsc_set_attr(vcpu, &attr);
 		break;
+	default:
+		KVM_BUG_ON(1, vcpu->kvm);
+		r = -EIO;
 	}
 
 	return r;
-- 
2.25.1

