Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 881B66D461C
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 15:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbjDCNtZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 09:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231444AbjDCNtY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 09:49:24 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48F66EAB
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 06:49:22 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id t4so24189102wra.7
        for <kvm@vger.kernel.org>; Mon, 03 Apr 2023 06:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680529761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kPw3ManZ+Ywd9V8K8Vksi6Xge0WhKBjH9baywEDj7Kk=;
        b=rmXfiWCZi0krL5XTl5WBBeWa7xwSGSOSUcp4MWBpXlZnAzVqL5X0NDXgrYBF0Y6vmL
         DT5vYJ7ECssrMD+zNhBRLKQV4Ul4EyurpiaxXJLUPMuAnVIHaOPw3/yoYZHchKAsqi6c
         dj6XNdYCsAJnQewEMdhmsQyTBzFt/XEuL1LtVgJttkXLJjfdHRdsp28EweTOGWbKdxP+
         cSpEDfSUoo+Moo76eHZQlnI2uPY2tysZX7JA50qffchQsJl9UhhEOfPcU4mXoAt8+wLO
         EwnWLGVOuraerzsaqU3vL9hU38vqWJajRaqtY0q6pQn9Y5hLot2rzjaB10TppgclWrWb
         egQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680529761;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kPw3ManZ+Ywd9V8K8Vksi6Xge0WhKBjH9baywEDj7Kk=;
        b=XWQk/l4wp5vNCUd4QBO0p98N/cyPq4SkNigTkG3RCdlWoN047iaq0wljGLn9eGZgJX
         tG6OMqRJjd9lbNmUVLufuNg1Cei6a88B1FzopDf+qCT+litHca13nwiR3NGjm+yufU4y
         0DN1q0EUfJ2SKeKRdt0WbkNYmDYt300MMGaMricwQCxfA/323YiH9NX/EP+vewxszqVX
         1NyrlmlJmS2qMVbmadzIWWmpzKR3htEl1yRDa2eXOKdWoRBKd93YbN5jqzX2dUHE2L5D
         g/tyoYvoAsW9/iPryvyF5zRnpeGIw4Z+JtrYpMglaEudrIax62BjFrTPB4sDwQ78pJnC
         pbhA==
X-Gm-Message-State: AAQBX9esaekO2IoBHvgowDmLK+GjcdXhkZtXUFvMSHNtx7yfWh3ABOk2
        nQEIWGa+K9pt28vaHTJwfI6VIVIe02cGL9SP9iQ=
X-Google-Smtp-Source: AKy350ZmeCjCwas3F11HTg/YpngWMJ8S9uOnUWYkwxB3VZ3DPtp0QmSizwnfAGoFaIIO2pFNqSFDGw==
X-Received: by 2002:adf:e44d:0:b0:2d0:d739:f901 with SMTP id t13-20020adfe44d000000b002d0d739f901mr28690522wrm.20.1680529761379;
        Mon, 03 Apr 2023 06:49:21 -0700 (PDT)
Received: from zen.linaroharston ([85.9.250.243])
        by smtp.gmail.com with ESMTPSA id t16-20020adfdc10000000b002e5ff05765esm9249097wri.73.2023.04.03.06.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 06:49:21 -0700 (PDT)
Received: from zen.lan (localhost [127.0.0.1])
        by zen.linaroharston (Postfix) with ESMTP id B2C941FFB7;
        Mon,  3 Apr 2023 14:49:20 +0100 (BST)
From:   =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To:     qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Ryo ONODERA <ryoon@netbsd.org>, qemu-block@nongnu.org,
        Hanna Reitz <hreitz@redhat.com>, Warner Losh <imp@bsdimp.com>,
        Beraldo Leal <bleal@redhat.com>,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        Kyle Evans <kevans@freebsd.org>, kvm@vger.kernel.org,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Cleber Rosa <crosa@redhat.com>, Thomas Huth <thuth@redhat.com>,
        Kevin Wolf <kwolf@redhat.com>
Subject: [PATCH v2 00/11] more misc fixes for 8.0 (tests, gdbstub, meta, docs)
Date:   Mon,  3 Apr 2023 14:49:09 +0100
Message-Id: <20230403134920.2132362-1-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Testing of kaniko as an alternative builder ran into the weeds so that
patch has been dropped. It looks like the gitlab registry doesn't
support layer caching. However the build also seems to be very
unstable leading to a bunch of container build failures, e.g.:

  https://gitlab.com/stsquad/qemu/-/pipelines/823381159/failures

I've also dropped the avocado version bump. We do gain two new patches
- one minor gdbstub fix for BSD and including the Xen KVM test.

It would be nice to get some review of the documentation update from
the block maintainers but if no one objects I still intend to merge it
in lieu of anything better.

I'll roll the PR tomorrow morning.

Alex.

Alex Bennée (6):
  scripts/coverage: initial coverage comparison script
  gdbstub: don't report auxv feature unless on Linux
  MAINTAINERS: add a section for policy documents
  qemu-options: finesse the recommendations around -blockdev
  metadata: add .git-blame-ignore-revs
  gitlab: fix typo

Daniel P. Berrangé (2):
  tests/qemu-iotests: explicitly invoke 'check' via 'python'
  tests/vm: use the default system python for NetBSD

David Woodhouse (1):
  tests/avocado: Test Xen guest support under KVM

Marco Liebel (1):
  Use hexagon toolchain version 16.0.0

Philippe Mathieu-Daudé (1):
  gdbstub: Only build libgdb_user.fa / libgdb_softmmu.fa if necessary

 MAINTAINERS                                   |  19 ++
 gdbstub/gdbstub.c                             |   2 +-
 .git-blame-ignore-revs                        |  21 +++
 .gitlab-ci.d/base.yml                         |   2 +-
 gdbstub/meson.build                           |   6 +-
 qemu-options.hx                               |   8 +-
 scripts/coverage/compare_gcov_json.py         | 119 ++++++++++++
 tests/avocado/kvm_xen_guest.py                | 170 ++++++++++++++++++
 .../dockerfiles/debian-hexagon-cross.docker   |   2 +-
 tests/qemu-iotests/meson.build                |   7 +-
 tests/vm/netbsd                               |   3 +-
 11 files changed, 347 insertions(+), 12 deletions(-)
 create mode 100644 .git-blame-ignore-revs
 create mode 100755 scripts/coverage/compare_gcov_json.py
 create mode 100644 tests/avocado/kvm_xen_guest.py

-- 
2.39.2

