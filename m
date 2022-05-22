Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D2A4530307
	for <lists+kvm@lfdr.de>; Sun, 22 May 2022 14:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344718AbiEVMW4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 May 2022 08:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiEVMWz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 May 2022 08:22:55 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D3403BBE2;
        Sun, 22 May 2022 05:22:54 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id f4so21246349lfu.12;
        Sun, 22 May 2022 05:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XRfWg+fADolIfuSMnQcCvTeo8WWZuP6coPsptzZ15Zo=;
        b=Jpp1WVJfjpx5sfKi9o0xU6v3+1cYklN0lbfX1+fgn3g0YQTDxYYOoP6NBWMSS0dFu+
         2nzm9LtcFeeJ7V0j7uhZhPjbqPjuhZpjmVKrK4uDqJk512oRkZvPNMAdI0/XUQNassHS
         pvkjdnYzgquEDDAk401q3Ib0kVDCFL7c4ezJmBWPrpgQH3qwUhjl8MHfhfzOeXFp2Nkk
         hsrhD9xFiGf3k2fzOxOry37dBAhxrIu4gmMFTddXPjucx+iJvdowatGuLov9OpSTf5ow
         +geqp32YJQoaGiyn1j3a2sRLlExRv5Ci+Gf0K62dA3rrpaSz4lZR15goaPcRPp3TD9c0
         Ja8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XRfWg+fADolIfuSMnQcCvTeo8WWZuP6coPsptzZ15Zo=;
        b=QkqTO+eDfwbtRApVslmPQUTWyVJ/NKs+/VgbdkmkZItrckhw51SYkU0KD1u3Dv4b4f
         VT3IuARFcx13Bg5unAdkfjNSXvwZuro4xBQBeYnUmpyfxUVjRwDGkMs2hbdFIIySiLSv
         ye8sowuPT9YJbYD6cGUohG8zNL0q9iEf6R7wDCdNbxpmbJGS67CkTDPrMNg/YPX5nCF0
         QROtBQQK/HvmX7n0IsgVIL00GXqsscUNZvSw4dyEsWNV49d0D02baWHGX/KhZoxnBc0j
         i+Ns95OTQ4gJVcRdIuqxvmWZ2qD4xRMkdP8keX6gBM8KdlUTNVUtz2xM3dEDEwqtdHuo
         Uk2Q==
X-Gm-Message-State: AOAM530lkPZhVebWZBdHULiWWEEhrzGVWQMoBqK0anTEMzT44/DzR3dL
        M5H43A93V+Idzopgd1nd1Apd21wnDzc2e8Ps
X-Google-Smtp-Source: ABdhPJyIYoNmUuNJRBbm7baPesHb98dp37/DtqE6vy81O13lZnqSeVO/k84JfU2g0zrTo8QVm4ACXA==
X-Received: by 2002:a05:6512:33c3:b0:473:d099:919 with SMTP id d3-20020a05651233c300b00473d0990919mr13755971lfg.430.1653222172718;
        Sun, 22 May 2022 05:22:52 -0700 (PDT)
Received: from fedora.. ([93.100.99.176])
        by smtp.gmail.com with ESMTPSA id q16-20020ac25a10000000b0047255d2112esm1434245lfn.93.2022.05.22.05.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 May 2022 05:22:52 -0700 (PDT)
From:   Dmitry Klochkov <kdmitry556@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Dmitry Klochkov <kdmitry556@gmail.com>
Subject: [PATCH] tools/kvm_stat: fix display of error when multiple processes are found
Date:   Sun, 22 May 2022 15:21:41 +0300
Message-Id: <20220522122141.11640-1-kdmitry556@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Instead of printing an error message, kvm_stat script fails when we
restrict statistics to a guest by its name and there are multiple guests
with such name:

  # kvm_stat -g my_vm
  Traceback (most recent call last):
    File "/usr/bin/kvm_stat", line 1819, in <module>
      main()
    File "/usr/bin/kvm_stat", line 1779, in main
      options = get_options()
    File "/usr/bin/kvm_stat", line 1718, in get_options
      options = argparser.parse_args()
    File "/usr/lib64/python3.10/argparse.py", line 1825, in parse_args
      args, argv = self.parse_known_args(args, namespace)
    File "/usr/lib64/python3.10/argparse.py", line 1858, in parse_known_args
      namespace, args = self._parse_known_args(args, namespace)
    File "/usr/lib64/python3.10/argparse.py", line 2067, in _parse_known_args
      start_index = consume_optional(start_index)
    File "/usr/lib64/python3.10/argparse.py", line 2007, in consume_optional
      take_action(action, args, option_string)
    File "/usr/lib64/python3.10/argparse.py", line 1935, in take_action
      action(self, namespace, argument_values, option_string)
    File "/usr/bin/kvm_stat", line 1649, in __call__
      ' to specify the desired pid'.format(" ".join(pids)))
  TypeError: sequence item 0: expected str instance, int found

To avoid this, it's needed to convert pids int values to strings before
pass them to join().

Signed-off-by: Dmitry Klochkov <kdmitry556@gmail.com>
---
 tools/kvm/kvm_stat/kvm_stat | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/kvm/kvm_stat/kvm_stat b/tools/kvm/kvm_stat/kvm_stat
index 5a5bd74f55bd..9c366b3a676d 100755
--- a/tools/kvm/kvm_stat/kvm_stat
+++ b/tools/kvm/kvm_stat/kvm_stat
@@ -1646,7 +1646,8 @@ Press any other key to refresh statistics immediately.
                          .format(values))
             if len(pids) > 1:
                 sys.exit('Error: Multiple processes found (pids: {}). Use "-p"'
-                         ' to specify the desired pid'.format(" ".join(pids)))
+                         ' to specify the desired pid'
+                         .format(" ".join(map(str, pids))))
             namespace.pid = pids[0]
 
     argparser = argparse.ArgumentParser(description=description_text,

base-commit: 9f46c187e2e680ecd9de7983e4d081c3391acc76
-- 
2.32.0

