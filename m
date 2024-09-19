Return-Path: <kvm+bounces-27137-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id BAE1297C386
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 06:48:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 400221F23436
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 04:48:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E11747A7C;
	Thu, 19 Sep 2024 04:47:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LOclbxg2"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763DA4436A
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 04:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726721239; cv=none; b=NP/cti/xyI9YFcDhCZn7dGa8EN31qAgGdVGH3c1pJ3h+3X+D/XEkBejlAbxENA+geKbHDc/5mcvHZYr9wrnzHDbuZ3XDVxdiDgHmsFxyyJbqoONtwjQmKPB35PlGhTsR0NgqjQM4Ca/c8rZVSX/sSy8cdz2xz0eiz0ZfAV33NtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726721239; c=relaxed/simple;
	bh=h1BQ1qfXStKpCFJlZi6Zn0TVFFLfvOkQnEdWt54KZLc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AN42ZHpbYJLX61SiNlALX+H78AAcEj2dbKlSpyOerGZ7P9NxrPLFBwiIVb+HUmg5giNC3v0KxCojqmJ7H12FTtKit1ZJn0gQFQF+GBUSA7SgRg3VygEb48o15zsv+W8iN5HZ69u1p+QpVY41ALi4AOAeUzSm3dB2O2XkhF83E+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LOclbxg2; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2054e22ce3fso4771635ad.2
        for <kvm@vger.kernel.org>; Wed, 18 Sep 2024 21:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726721238; x=1727326038; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3PbYSPAJ6rnlNnfP+6+lqxv7ue/rw4dEH/6Q+9usd0U=;
        b=LOclbxg2fe37awpHnXv9xjUBuCmdshO5MOLhHSe52UL80TjDxGfOuEGpISTiQ7gvpi
         d8OWSET9V51Ja4iTxzQWRBBHF1lWRxN/Sldql/tNxVj6bOIGVPrgoAmVJqeQ0UhQt6v3
         xtcWb6WQpYxuqkOUZLFip2bvOUcchyyQsu+RJ+1QS/Kh+YVyirdNdGAD4Zz6HEVorxg/
         XBoWPBVt/B/hGqBsV5QzfIuZcDzcyoWWu2kmqpEfGfw+6vSZE0rVReDcRPp/Ab8K811/
         lZ9AIiVn93x4xm77t0brjOP+dTM4UILWtr/EfMEdU1A7vUsM7FN9DEg1Y93Q4HdPd+A5
         2UtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726721238; x=1727326038;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3PbYSPAJ6rnlNnfP+6+lqxv7ue/rw4dEH/6Q+9usd0U=;
        b=GT2XnYeW8i3hecLBs106rvwsPXeIgEDaVbSBDstb2eOwCXeXYKuQRRHwFMBZRXKNQ7
         NuPCbGXxrdrgf1R8z3kKxlfywIpQVgTAy0e3SY94JXDDoyyPnDR67uncR6zh0vcqYTop
         gbWQbj9cr48iBmvZ3BlQHM1cp72u89CwfVSxyI3+BCLhZu+7ISBuBHlGMkJRwQpYdHpK
         kdVYd955cuGKokkhWLXuLws/iXr3YBcxKSFInyQqhqHPH56tApDPVsS3RdgL298c9twx
         3U/bdrELYHgq2qeWiwr2s255fw02xRDky7/CkPf0w9pH2XWpZaHnT+sd2bVFAfO/y0zF
         rZ5g==
X-Forwarded-Encrypted: i=1; AJvYcCXtr2Z1XCgLF0VjBrOqApNA2IMK579aYzLUQ3xEeUIfq9fblNqnvKxqEWWzgyudW0gz27o=@vger.kernel.org
X-Gm-Message-State: AOJu0YwLKOYAFUvjW7UlDZs1gYjzntmlsEZj8deSAsLpxxabiWLBcVbM
	Y2hFP/TQ6wyvuhLMJRmx4GOk4YwCU/xxbvg5UMh+/TZPa0kjSSp7soj0tnc0zNY=
X-Google-Smtp-Source: AGHT+IF3mDmH9rpxImg7I9ZiTJydkdGhhv3x9u+IP9aPf7aanW6JNd2XCY8CeZpnshOcXFIkUiIf+g==
X-Received: by 2002:a05:6a20:43a0:b0:1d2:e8f6:7e6 with SMTP id adf61e73a8af0-1d2e8f60a4bmr8759330637.13.1726721237824;
        Wed, 18 Sep 2024 21:47:17 -0700 (PDT)
Received: from linaro.. (216-180-64-156.dyn.novuscom.net. [216.180.64.156])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71944bc279csm7478601b3a.188.2024.09.18.21.47.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2024 21:47:17 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Palmer Dabbelt <palmer@dabbelt.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Hyman Huang <yong.huang@smartx.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	kvm@vger.kernel.org,
	Bin Meng <bmeng.cn@gmail.com>,
	Peter Xu <peterx@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	qemu-s390x@nongnu.org,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Corey Minyard <minyard@acm.org>,
	Laurent Vivier <laurent@vivier.eu>,
	WANG Xuerui <git@xen0n.name>,
	Thomas Huth <thuth@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Ani Sinha <anisinha@redhat.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Fam Zheng <fam@euphon.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Keith Busch <kbusch@kernel.org>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	qemu-riscv@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Jason Wang <jasowang@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Markus Armbruster <armbru@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-arm@nongnu.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Zhao Liu <zhao1.liu@intel.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	qemu-block@nongnu.org,
	Joel Stanley <joel@jms.id.au>,
	Weiwei Li <liwei1518@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Yanan Wang <wangyanan55@huawei.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Jesper Devantier <foss@defmacro.it>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v3 16/34] block: remove break after g_assert_not_reached()
Date: Wed, 18 Sep 2024 21:46:23 -0700
Message-Id: <20240919044641.386068-17-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
References: <20240919044641.386068-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch is part of a series that moves towards a consistent use of
g_assert_not_reached() rather than an ad hoc mix of different
assertion mechanisms.

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
Reviewed-by: Richard W.M. Jones <rjones@redhat.com>
Reviewed-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 block/ssh.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/block/ssh.c b/block/ssh.c
index 27d582e0e3d..871e1d47534 100644
--- a/block/ssh.c
+++ b/block/ssh.c
@@ -474,7 +474,6 @@ static int check_host_key(BDRVSSHState *s, SshHostKeyCheck *hkc, Error **errp)
                                        errp);
         }
         g_assert_not_reached();
-        break;
     case SSH_HOST_KEY_CHECK_MODE_KNOWN_HOSTS:
         return check_host_key_knownhosts(s, errp);
     default:
-- 
2.39.5


