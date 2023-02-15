Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A54169827C
	for <lists+kvm@lfdr.de>; Wed, 15 Feb 2023 18:44:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbjBORn7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Feb 2023 12:43:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBORn6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Feb 2023 12:43:58 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558C53C298
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:43:57 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id m14so19950207wrg.13
        for <kvm@vger.kernel.org>; Wed, 15 Feb 2023 09:43:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1qgw8+Wwe6UbEIQRuVneXNaCb/C9jGyBn8UJr2mvMpE=;
        b=OUQYxjBOzhi4iZJef7RmHx3pYvwnmJUQ9l254ANvT2XMvaNRjgh549I0BaL2o47oQM
         jEHSngvage9JIW3vJigdLEUyqataQvj3iecmCSgaj+oITeCWfqBIO9G9ZNyzuYyx8TCo
         LT4l2JYUwrNY/oSrO6U82VGZeA3zn0fjqvRUMHjQJElb6QqLyqzAwnXZpwn2qQ+XpmDl
         xejTlxSPs7dSIl9n+MgYiiUzOleavDjjTIrgaj12JaHZJ1CQ5mZ28SRb2MDfil4ksVnW
         JEr9Vj2QmEWvtSVaD0hxOjWlT54LqcvP9dpDm3ln7tRP9hItK4p9WnozsISPz3ACuEXP
         1QSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1qgw8+Wwe6UbEIQRuVneXNaCb/C9jGyBn8UJr2mvMpE=;
        b=Otpuw2xTrGp4blsKU8nsTZnzZTEKadQawko2ubPgLqyljqwX7QmwP/CCT/qXcksvTM
         ihABbKaCvbdZwZI3K7stoPmMw0laUVzglIwbYTUMLcrNFSfBYIP/lD2J+423fQpx9FF/
         ecTz2IM7QeXfQcE9hUZkPnixkpGyzAyr7+f/a7cZYV/qgc1V0Zg11ascHeDkpXad+OC1
         GafT+0HXXyWVpUc+3FTEhScV04VKzCu6vI0mFWfAL8w42ZbUgOaR5354DecovE//zsnj
         gWf9y1ZF0abnW/Il0zFFzVJK1rcuAfddRW6cVFZn7kR5BnbXL2vw4ieu7CVpUOS0cCsb
         +woA==
X-Gm-Message-State: AO0yUKWMlFjTvY6qhnoXasEaWXodwGmK+PlBeegjCmqEEI6vT5jNIYk1
        Y013CUVIUfbuwfBJtjPFmkiyhg==
X-Google-Smtp-Source: AK7set+gN7zPm/eZBuNOrogb8C7yyYd5GMjKJw0HuEPzZaP/Jq4izkNObYCrrwIqDlZz0ODyc4yUKQ==
X-Received: by 2002:adf:fdc3:0:b0:2c5:4480:b590 with SMTP id i3-20020adffdc3000000b002c54480b590mr2456780wrs.54.1676483035789;
        Wed, 15 Feb 2023 09:43:55 -0800 (PST)
Received: from localhost.localdomain ([81.0.6.76])
        by smtp.gmail.com with ESMTPSA id g9-20020a5d5409000000b002c558228b6dsm8674648wrv.12.2023.02.15.09.43.54
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 15 Feb 2023 09:43:55 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Marcelo Tosatti <mtosatti@redhat.com>,
        Sergio Lopez <slp@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        kvm@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <eduardo@habkost.net>, qemu-ppc@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Subject: [PATCH 0/5] hw/timer/i8254: Un-inline and simplify IRQs
Date:   Wed, 15 Feb 2023 18:43:48 +0100
Message-Id: <20230215174353.37097-1-philmd@linaro.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

i8254_pit_init() uses a odd pattern of "use this IRQ output
line if non-NULL, otherwise use the ISA IRQ #number as output".

Rework as simply "Use this IRQ output".

Un-inline/rename/document functions.

Based-on: <20230215161641.32663-1-philmd@linaro.org>
          "hw/ide: Untangle ISA/PCI abuses of ide_init_ioport" v2
https://lore.kernel.org/qemu-devel/20230215161641.32663-1-philmd@linaro.org/

Philippe Mathieu-Daudé (5):
  hw/timer/hpet: Include missing 'hw/qdev-properties.h' header
  hw/timer/i8254: Factor i8254_pit_create() out and document
  hw/i386/pc: Un-inline i8254_pit_init()
  hw/timer/i8254: Really inline i8254_pit_init()
  hw/i386/kvm: Factor i8254_pit_create_try_kvm() out

 hw/i386/kvm/i8254.c        | 18 ++++++++++++++
 hw/i386/microvm.c          |  6 +----
 hw/i386/pc.c               | 15 +++++-------
 hw/isa/i82378.c            |  2 +-
 hw/isa/piix4.c             |  4 ++--
 hw/isa/vt82c686.c          |  2 +-
 hw/mips/jazz.c             |  2 +-
 hw/timer/hpet.c            |  1 +
 hw/timer/i8254.c           | 16 +++++++++++++
 include/hw/timer/i8254.h   | 48 +++++++++++++-------------------------
 target/i386/kvm/kvm-stub.c |  6 +++++
 11 files changed, 69 insertions(+), 51 deletions(-)

-- 
2.38.1

