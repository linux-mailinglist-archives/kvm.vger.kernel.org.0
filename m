Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06CA411397D
	for <lists+kvm@lfdr.de>; Thu,  5 Dec 2019 03:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbfLECDy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Dec 2019 21:03:54 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:60062 "EHLO
        www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728121AbfLECDy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Dec 2019 21:03:54 -0500
Received: from fsav301.sakura.ne.jp (fsav301.sakura.ne.jp [153.120.85.132])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id xB51xvft020982;
        Thu, 5 Dec 2019 10:59:57 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav301.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav301.sakura.ne.jp);
 Thu, 05 Dec 2019 10:59:57 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav301.sakura.ne.jp)
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id xB51xvmN020973;
        Thu, 5 Dec 2019 10:59:57 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Received: (from i-love@localhost)
        by www262.sakura.ne.jp (8.15.2/8.15.2/Submit) id xB51xuco020972;
        Thu, 5 Dec 2019 10:59:56 +0900 (JST)
        (envelope-from penguin-kernel@i-love.sakura.ne.jp)
Message-Id: <201912050159.xB51xuco020972@www262.sakura.ne.jp>
X-Authentication-Warning: www262.sakura.ne.jp: i-love set sender to penguin-kernel@i-love.sakura.ne.jp using -f
Subject: Re: KASAN: slab-out-of-bounds Read in =?ISO-2022-JP?B?ZmJjb25fZ2V0X2Zv?=
 =?ISO-2022-JP?B?bnQ=?=
From:   Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Grzegorz Halat <ghalat@redhat.com>
Cc:     syzbot <syzbot+4455ca3b3291de891abc@syzkaller.appspotmail.com>,
        aryabinin@virtuozzo.com, daniel.thompson@linaro.org,
        dri-devel@lists.freedesktop.org, dvyukov@google.com,
        gleb@kernel.org, gwshan@linux.vnet.ibm.com, hpa@zytor.com,
        jmorris@namei.org, kasan-dev@googlegroups.com, kvm@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, mingo@redhat.com,
        mpe@ellerman.id.au, pbonzini@redhat.com, ruscur@russell.cc,
        serge@hallyn.com, stewart@linux.vnet.ibm.com,
        syzkaller-bugs@googlegroups.com, takedakn@nttdata.co.jp,
        tglx@linutronix.de, x86@kernel.org
MIME-Version: 1.0
Date:   Thu, 05 Dec 2019 10:59:56 +0900
References: <0000000000002cfc3a0598d42b70@google.com> <0000000000003e640e0598e7abc3@google.com>
In-Reply-To: <0000000000003e640e0598e7abc3@google.com>
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello.

syzbot is reporting that memory allocation size at fbcon_set_font() is too small
because font's height is rounded up from 10 to 16 after memory allocation.

----------
diff --git a/drivers/video/fbdev/core/fbcon.c b/drivers/video/fbdev/core/fbcon.c
index c9235a2f42f8..68fe66e435d3 100644
--- a/drivers/video/fbdev/core/fbcon.c
+++ b/drivers/video/fbdev/core/fbcon.c
@@ -2461,6 +2461,7 @@ static int fbcon_get_font(struct vc_data *vc, struct console_font *font)
 
 	if (font->width <= 8) {
 		j = vc->vc_font.height;
+		printk("ksize(fontdata)=%lu font->charcount=%d vc->vc_font.height=%d font->width=%u\n", ksize(fontdata), font->charcount, j, font->width);
 		for (i = 0; i < font->charcount; i++) {
 			memcpy(data, fontdata, j);
 			memset(data + j, 0, 32 - j);
@@ -2661,6 +2662,8 @@ static int fbcon_set_font(struct vc_data *vc, struct console_font *font,
 	size = h * pitch * charcount;
 
 	new_data = kmalloc(FONT_EXTRA_WORDS * sizeof(int) + size, GFP_USER);
+	if (new_data)
+		printk("ksize(new_data)=%lu h=%u pitch=%u charcount=%u font->width=%u\n", ksize(new_data), h, pitch, charcount, font->width);
 
 	if (!new_data)
 		return -ENOMEM;
----------

Normal usage:

[   27.305293] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8
[   27.328527] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8
[   27.362551] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8
[   27.385084] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8
[   27.387653] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8
[   27.417562] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8
[   27.437808] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8
[   27.440738] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8
[   27.461157] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8
[   27.495346] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8
[   27.607372] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8
[   27.655674] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8
[   27.675310] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8
[   27.702193] ksize(new_data)=8192 h=16 pitch=1 charcount=256 font->width=8

syzbot's testcase:

[  115.784893] ksize(new_data)=4096 h=10 pitch=1 charcount=256 font->width=8
[  115.790269] ksize(fontdata)=4096 font->charcount=256 vc->vc_font.height=16 font->width=8
