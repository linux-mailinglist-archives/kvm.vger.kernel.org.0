Return-Path: <kvm+bounces-26375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 00E119745AB
	for <lists+kvm@lfdr.de>; Wed, 11 Sep 2024 00:19:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC307289711
	for <lists+kvm@lfdr.de>; Tue, 10 Sep 2024 22:19:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41B0E1B3734;
	Tue, 10 Sep 2024 22:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uJpSM9aF"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B801B2ECE
	for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 22:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726006631; cv=none; b=KH9+v74UIIh/iqMd4IxII7ul6QQoPVjOQjrJlJmVbBN6TypgMgyMp1BRXJe7UiiJCAiEny4rRF2fszZCANH5PL9jzVWYF6r58GWa1M+8J5kVRcpz9RCYJ36RFE9p6SvoiC5vvkoF9RPc9S13aJ4YD/nNieUuIQeWAOK6gVqy5rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726006631; c=relaxed/simple;
	bh=uRQ03x5IMXAeXMu1hODTGnUsUsRLyDGwZwtJs196/ns=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=PlXwNMBeMFz50zCkYElpBSQ6+YTAY5Z6iZzAoE4T6bw9WKNKWQ306SUz6RkeWnGwCqSVv3WK78CiRZjivOKdMB8PIdTcB0IpOukX8Ei+bYjeZgOyNrKoFexI8HwDsqxTRddqQMUH8XmHuTG7zOkK93h1anr8CEL3EYAwATy+TEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uJpSM9aF; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-718e1ce7e84so3015948b3a.1
        for <kvm@vger.kernel.org>; Tue, 10 Sep 2024 15:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726006629; x=1726611429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RCGVOkz/BgjMXg0ik5e1jthdc26fdQDBLF+1lu12foY=;
        b=uJpSM9aFhaCjIsN3r105AJND5WLaPayfhdbeXjySfliKEjHn83DchqQNRVrJbqhx7a
         WxNWlDCjwZ9shW6zAZ2pXws8oSWe38nVfeMOQZdh+5VGSPGAhNbgYwEZ4c8dxmKAqDKs
         rOLmdbjlRgDwjOhFMmTj1s/Jk4SieSLkMTwZdLlctNPz72NBCTwR8xn2MRQ20I2mnZYb
         ShMoSQRRI+sDv2vP8yYK1c5F5C+QxYRbyLZ6iAp/9vM6RzQUPBV8Jq7LUCAclsbhrBau
         PJi7dko3nZFHnfDYQtgW//qGPpCMmdBT0vljU/ajFxzqNnTsPIA1ZVIUZIRdEw15qOB9
         tkeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726006629; x=1726611429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RCGVOkz/BgjMXg0ik5e1jthdc26fdQDBLF+1lu12foY=;
        b=BKS5uLQ71ORufgMsJklNnwwsjGoX1HgCQt/OC50y14pxaulCAjQQ46DHi3CJv2oOLU
         EkMR3F0afyOh6jp7ARM/9banePUmz607+s9ThLcQtELA7kgOs+CKUiSSIiu0LVCb/HvC
         DIvEaklKOUiYr7+FqSJ0IqsfuMZ74c3P/vYaYdFwkFNh5ViVKDkM9p/1Ilvj8bUJjGk1
         rPT1s5bsJ66LGcY5fOKiKYfTTthYWb1v7SjkJJUX8gtOrjU02MWQyL7u3t7X0DNOaXhf
         MzvddD0k8A6XxxPV4CND9mrHMm+W5272/leOZ0Vc4GZyr3msvMb94/0r9Clq0K4Bh791
         l6pQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFLM9I7gWg/E+kuF3/hl+JVEAAGDmKgLvO1R/133zVTkT8FDWbGtd23+RPXHIdqMAkcsQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0ZjbPcS9b4PRWh1kXgn7RP3J+NbyYp7yDFD4jjDZqcPYayncN
	3Helnuo5jIWWutsryM2UlvEAL5C+pUYEtiWsJd+05QCd9moF3qz61/vWmBOSkP4=
X-Google-Smtp-Source: AGHT+IGi72IfaYUiCGQt7lWSGV2AP/QNzvbmyXN6XQj5zV/aN0oGXhyf4mxvjQxKuaGQQoLA5lFr1g==
X-Received: by 2002:a05:6a21:6e41:b0:1cf:5437:e768 with SMTP id adf61e73a8af0-1cf5e03316emr3202667637.7.1726006629425;
        Tue, 10 Sep 2024 15:17:09 -0700 (PDT)
Received: from linaro.vn.shawcable.net ([2604:3d08:9384:1d00::9633])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71909003d0esm1884055b3a.93.2024.09.10.15.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2024 15:17:09 -0700 (PDT)
From: Pierrick Bouvier <pierrick.bouvier@linaro.org>
To: qemu-devel@nongnu.org
Cc: Zhao Liu <zhao1.liu@intel.com>,
	"Richard W.M. Jones" <rjones@redhat.com>,
	Joel Stanley <joel@jms.id.au>,
	Kevin Wolf <kwolf@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	qemu-arm@nongnu.org,
	Corey Minyard <minyard@acm.org>,
	Eric Farman <farman@linux.ibm.com>,
	Thomas Huth <thuth@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	WANG Xuerui <git@xen0n.name>,
	Hyman Huang <yong.huang@smartx.com>,
	Stefan Berger <stefanb@linux.vnet.ibm.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Alistair Francis <alistair.francis@wdc.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	qemu-riscv@nongnu.org,
	Ani Sinha <anisinha@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Jesper Devantier <foss@defmacro.it>,
	Laurent Vivier <laurent@vivier.eu>,
	Peter Maydell <peter.maydell@linaro.org>,
	Igor Mammedov <imammedo@redhat.com>,
	kvm@vger.kernel.org,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Richard Henderson <richard.henderson@linaro.org>,
	Fam Zheng <fam@euphon.net>,
	qemu-s390x@nongnu.org,
	Hanna Reitz <hreitz@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Laurent Vivier <lvivier@redhat.com>,
	Rob Herring <robh@kernel.org>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	qemu-block@nongnu.org,
	"Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
	qemu-ppc@nongnu.org,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Fabiano Rosas <farosas@suse.de>,
	Helge Deller <deller@gmx.de>,
	Dmitry Fleytman <dmitry.fleytman@gmail.com>,
	Daniel Henrique Barboza <dbarboza@ventanamicro.com>,
	Akihiko Odaki <akihiko.odaki@daynix.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	David Gibson <david@gibson.dropbear.id.au>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	Peter Xu <peterx@redhat.com>,
	Bin Meng <bmeng.cn@gmail.com>,
	Weiwei Li <liwei1518@gmail.com>,
	Klaus Jensen <its@irrelevant.dk>,
	Jean-Christophe Dubois <jcd@tribudubois.net>,
	Jason Wang <jasowang@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>
Subject: [PATCH 25/39] block: remove break after g_assert_not_reached()
Date: Tue, 10 Sep 2024 15:15:52 -0700
Message-Id: <20240910221606.1817478-26-pierrick.bouvier@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
References: <20240910221606.1817478-1-pierrick.bouvier@linaro.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
2.39.2


