Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36E4554B04B
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 14:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245138AbiFNMQG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 08:16:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357344AbiFNMOD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 08:14:03 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4BD6645D;
        Tue, 14 Jun 2022 05:13:59 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id c4so13558812lfj.12;
        Tue, 14 Jun 2022 05:13:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nKnYN08Rvu+sGq1kjp6kIVR2Yb7qukUUQYO6d9aq840=;
        b=UVwRVot3MFBq+hv/KyFkRHUAclCqFG7m8zNbldLx5L74fAdbiRBja5B/SqzL2U2Fj1
         TXkily+0cEdsd3X/rxouV7qXh5kkamBenh5nvRcBm2Tkz7hrlKxD927RkHXO8G2fb8ie
         sgWp0d5GDJZSiQHzACFlTp2qxS9StkCGfiofMKFAeL++TVdgK5tLGgwVpxTYWGMLmdqu
         9ZHkRtd8NKpByTZjhI6APV0WCPZ6P7XmVOLhbJPY/N9uIUwQhU2+h5H6YyY+ZoSCwv8L
         1cHgs8ScimkDbQMaxVCQYdS6iLyfAPz7LZr9ApPbD3bp+DJFOjYZ03r2DVP1FmYIhEtt
         9jqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nKnYN08Rvu+sGq1kjp6kIVR2Yb7qukUUQYO6d9aq840=;
        b=H/Om1rIkDsBHAB5eCCp5MeyUu0S97ZituVBoPaCoQQ/SQMurqkXb/WwDpWPx50cPqq
         0LHVMe0hQ57CPw8NWtMqYp8l8ogalLLShlQG5yJPYtuY7eE/w85tqWqB4L19cEdZqZVX
         tYWturRL9867rhVKYnl/Vpo53Ty0xpBl/JcvGAIgyhKGjdpN0K//zhivr2M/S6mto0aQ
         mWiLN3mBRHS+KAYFlO2qte8y7RHhQjXIZi1YQNkrtZ1VMraozMzeB/lkaDzXcLfHEmg3
         tjntP9RhX5Y5YodddtOSvVkA8Y2YjsvT6tsHX5vySSdmeaONNO2BJVUdWb6eZDQFyZQ7
         MFeQ==
X-Gm-Message-State: AOAM530qByMdDCOZuskdy57PQMdA6vLxOMcoXvNNtypzfYo/GDL8AKVx
        IWcqhENm0Thlxfyvw9aULYFGp7hE1mFj5Q==
X-Google-Smtp-Source: ABdhPJzvhoikkeI4AYAF87Ur8EBNChUytYJ6RX2xRy9QqGSs2limrTNWZEcuAkHDrJY286cDy6ABkA==
X-Received: by 2002:a19:8c11:0:b0:478:f5e1:e799 with SMTP id o17-20020a198c11000000b00478f5e1e799mr2869688lfd.548.1655208837738;
        Tue, 14 Jun 2022 05:13:57 -0700 (PDT)
Received: from fedora.. ([93.100.99.176])
        by smtp.gmail.com with ESMTPSA id d2-20020a056512368200b004790c425b35sm1373727lfs.291.2022.06.14.05.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:13:57 -0700 (PDT)
From:   Dmitry Klochkov <kdmitry556@gmail.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Raspl <raspl@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Dmitry Klochkov <kdmitry556@gmail.com>
Subject: [PATCH RESEND] tools/kvm_stat: fix display of error when multiple processes are found
Date:   Tue, 14 Jun 2022 15:11:41 +0300
Message-Id: <20220614121141.160689-1-kdmitry556@gmail.com>
X-Mailer: git-send-email 2.35.3
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

base-commit: 6cd88243c7e03845a450795e134b488fc2afb736
-- 
2.35.3

