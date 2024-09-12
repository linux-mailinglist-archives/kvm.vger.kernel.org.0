Return-Path: <kvm+bounces-26647-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 15185976312
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 09:42:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BFB102810FB
	for <lists+kvm@lfdr.de>; Thu, 12 Sep 2024 07:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0240D18C330;
	Thu, 12 Sep 2024 07:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tdMZKn2t"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3FA918F2DF
	for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 07:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726126850; cv=none; b=FlDLLPgpQtAfkVrT2ku9K3R+c0a18ZhQxGgCcvAeMRlqcj7HCpZzR9TxqOWL0plXYvxThirCDr+HNdDA0NiEZOQFDzz7kYDzIm17CyxkKpLopYp7gYOpZjWFVladdcwbGbDLAnWar2L1YBjhCW/T5KdCn8maGEixMRPsBvhqWNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726126850; c=relaxed/simple;
	bh=ZFp789VAva/F0U9wgHfw2gutxCS7yC4LhuLCH+J497w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cGWLIlSvKiLIamEay6BW87/yUNna6raEexVs45LRrvA506ORTBE4+Z+TF1ahl2Fs19+EkhLHdrT6FLdEukHCfSo98ahikAfs/Crtr8Yl2zWj8Og3N+S5vthd+anzA0j87keXI7hJt4EI2J6d+w585FdKUwkHuZnk23wf+chM4Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tdMZKn2t; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-71788bfe60eso454878b3a.1
        for <kvm@vger.kernel.org>; Thu, 12 Sep 2024 00:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726126848; x=1726731648; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PpoFW3JjD5zeg9AjFjAz2aaQ3UrReIS3eTyx8szr/r0=;
        b=tdMZKn2tZWJjDTrG8Wf63db6GxQGyx74vXYsJYS7Uhwg6gUBEUdRXC76kBWp92cXyP
         zVhm5JKT3Otx0ntmogVI/G+Bnv51hDWPs9RjxcP1DRADVHTYFlI8WmN+c//DbPMcAAcy
         pW9n9egrF53awZBUIFlFtVk//LBrrGxFLu+er2z9Nz9dBCjk/YgOe2xCVb0MiC9Qe0VR
         DquulfZ/n8KCKlUWNxQaKW3WrkY1pqFjS8KjKpW/tJIFHcaIZJ5apY7XpnDyB/71Q7cF
         A4dcaoE14XTdyH9AmBbFXrmG1dtkWECNpG8vkyuGrrxr7Fk8YkLKz8GJF3eqP8ev/ybM
         8DzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726126848; x=1726731648;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PpoFW3JjD5zeg9AjFjAz2aaQ3UrReIS3eTyx8szr/r0=;
        b=Ythrk5D7V6UYh4qCjRrg8/7uw/G03jwa3zUuxtGbrLZ5aZiNPwwQb+EQh7dGZDC2+E
         Z4f02WXsI9LRQu7EumlCH/bdGNbBdRhhs2vnyMpLnBxLqEWDWY0SBiapSOeHyXKajYkW
         jGbvIX3UFeptd3V0vRQNQdxfn0S2rsCWLagZ96e+0lcPRZkqf1jDR4j8Jd7IGm/oMSGV
         11XSCrU+JceqfPJ6Z6JoLKG9bOAv1/tCIePCI+VZ3wNFXthUsDjeSrXeAuah8S0UaX1Q
         zDP6GjDVlIs9xbEuwHRUjDYY0pQCvrkOe3lsYOew45lRRGeOzsn8/CAGY3ZiAmB63uX3
         SaGg==
X-Forwarded-Encrypted: i=1; AJvYcCWkBmF9I9yJ03lnWEBpVLM951Bzwd/7rVCJF9ClVFx7goPbotDd8cKb3ZFhKv4QZ+dkK/Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxNiL9CtKFZV58I/YU3RdmnVN8hl52kkFXoeuqlK1mwT8ctNtUt
	fwX79n+U7l+mCRrjY8bseU5Nkxl2C7Ut0Vh89hKQXhFyMpMnHgr16lY18C9BWOw=
X-Google-Smtp-Source: AGHT+IHrNzFr8rAxfNqGUQ/W4jAVrPS/G+v+L27QxJD+DkA0TVwS9jjC8lWOw+J53BlKzThCp6mjqQ==
X-Received: by 2002:a05:6a00:8d0:b0:706:5dab:83c4 with SMTP id d2e1a72fcca58-71926087f29mr3097493b3a.14.1726126848124;
        Thu, 12 Sep 2024 00:40:48 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7db1fb9ad87sm983458a12.6.2024.09.12.00.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 00:40:47 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	WANG Xuerui <git@xen0n.name>,
	Halil Pasic <pasic@linux.ibm.com>,
	Rob Herring <robh@kernel.org>,
	Michael Rolnik <mrolnik@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fabiano Rosas <farosas@suse.de>,
	Corey Minyard <minyard@acm.org>,
	Keith Busch <kbusch@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jesper Devantier <foss@defmacro.it>,
	Hyman Huang <yong.huang@smartx.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-s390x@nongnu.org,
	Laurent Vivier <laurent@vivier.eu>,
	qemu-riscv@nongnu.org,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Aurelien Jarno <aurelien@aurel32.net>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	kvm@vger.kernel.org,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Ani Sinha <anisinha@redhat.com>,
	qemu-ppc@nongnu.org,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Helge Deller <deller@gmx.de>,
	Peter Xu <peterx@redhat.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-arm@nongnu.org,
	Igor Mammedov <imammedo@redhat.com>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Eric Farman <farman@linux.ibm.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	qemu-block@nongnu.org,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Joel Stanley <joel@jms.id.au>,
	Eduardo Habkost <eduardo@habkost.net>,
	David Gibson <david@gibson.dropbear.id.au>,
	Fam Zheng <fam@euphon.net>,
	Weiwei Li <liwei1518@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH v2 31/48] hw/scsi: remove break after g_assert_not_reached()
Date: Thu, 12 Sep 2024 00:39:04 -0700
Message-Id: <20240912073921.453203-32-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
References: <20240912073921.453203-1-pierrick.bouvier@linaro.org>
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
Reviewed-by: Kevin Wolf <kwolf@redhat.com>
Signed-off-by: Pierrick Bouvier <pierrick.bouvier@linaro.org>
---
 hw/scsi/virtio-scsi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/hw/scsi/virtio-scsi.c b/hw/scsi/virtio-scsi.c
index 9f02ceea099..6637cfeaf51 100644
--- a/hw/scsi/virtio-scsi.c
+++ b/hw/scsi/virtio-scsi.c
@@ -357,7 +357,6 @@ static void virtio_scsi_do_one_tmf_bh(VirtIOSCSIReq *req)
 
     default:
         g_assert_not_reached();
-        break;
     }
 
 out:
-- 
2.39.2


