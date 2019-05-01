Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 162E7107B4
	for <lists+kvm@lfdr.de>; Wed,  1 May 2019 14:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfEAMAB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 May 2019 08:00:01 -0400
Received: from mail-qt1-f177.google.com ([209.85.160.177]:40646 "EHLO
        mail-qt1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfEAMAB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 May 2019 08:00:01 -0400
Received: by mail-qt1-f177.google.com with SMTP id y49so13992783qta.7
        for <kvm@vger.kernel.org>; Wed, 01 May 2019 05:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=2m773Wta5X4RVdWMQzg9kBuxmqtOLE9JAjLNEPsUkV8=;
        b=ei8mZCuRyAC/Ap/U4zi80oCWg+6V8rSYhZECIIkfOO9/UkSGhkmVA+WilcnVL5+PVw
         JH+SDhFyJgUNfukefHGQO20d9NyOBiN91xYOGzXSAuP65ErCloGCEh7Z4NGT++HCXEQb
         +vFWNC3y/tEIkWpCbUSOgom8cq6/T4gpWBELrQuO/tTJKNbsp5L3Yfkh+j48PapqVe4I
         1568Usdl7u90QQZyp5hnqb58mcvsES9goA6a4Xy4h69wubFDjRPIERl3Q56i5kwJxD+v
         q8Mq5jZO1zLSigqRq2ABALRVqwwLNXuxSUYMKydvXM+/SnIetWeJd/G69CoIUybuZ358
         Ui1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=2m773Wta5X4RVdWMQzg9kBuxmqtOLE9JAjLNEPsUkV8=;
        b=YWJDJBsh0yNxr9NJU56/ctyPYtiCo6lZqz0QSoRsM6SaG92kD8oNOsfslx3lGbj9dC
         HdCMG7qpj7FOqs6W3ciEWwKG3uVroxREEV+rgRQWmrnmwXGTCBeAHnTgAJTxTS9RrlCj
         ufjGaCGMB042gJOizGQWB9PVF6+qeJnwFteKnqgncrRlvNfiq60PmjTk1rotBswcdUUS
         qQ/vl/coTlVagI6J5ohPTvtlOPeuw77TA1VTYyiKOrjM/omq0gfzC3VxZbGBWrdJ0tj9
         8yEnRqBq5/pRxCSHrPyeNo6twkZ+E5xDWmbeFdxMLj+1n5AEdfDygvT8BbDa79XDFEta
         FVhQ==
X-Gm-Message-State: APjAAAWAWSpoSm3U9r9yYsMAAeMWZYsqkdUurqHFhlBC8iDlDHnfebvZ
        ahs7Zxrws/EoTEDPayiTxz5RwhodsLH2haqbhgNBMvMAlwhteA==
X-Google-Smtp-Source: APXvYqy670oe1IlL9a+5eNH+TMHElExPlD+Lhr21wYY4JK9jINdYsv+GKApw+et1ERxX5EpeUr8uTpbHHjgCGWLvgeU=
X-Received: by 2002:aed:3e58:: with SMTP id m24mr40682232qtf.364.1556712000398;
 Wed, 01 May 2019 05:00:00 -0700 (PDT)
MIME-Version: 1.0
From:   Bryan Muir <conlaoch@gmail.com>
Date:   Wed, 1 May 2019 07:59:49 -0400
Message-ID: <CALf=aXWYfNV1aULiD8KUPMn3Xng9upVRpj_LzTYDPMRFiT-J=w@mail.gmail.com>
Subject: Speeding up VM Startup
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I've been tasked with speeding up our VM usage.  At the moment it
takes an individual instance of our VM about 30 seconds to totally
boot to a logon screen that a user an interact with.  We are using
qemu/kvm on a Centos7 infrastructure.

rpm-qa shows:
qemu-kvm 1.5.3
qemu 2.0.0.1
and all the supporting packages from yum

What I am looking to be able to do is to take our guest OS to the
logon screen, suspend the VM, and save the VM image with state.  That
way when I need to spin up a new VM it would begin by resuming at the
logon state.

So far I've tried the following

1.  suspend at logon screen, qemu-img to newfile , virsh start newfile
  (can see kvm go through boot/post)
2.  suspend at logon, virt-clone to new file, virsh start   (os boots/post)
3.  take running snapshot at logon, revert to snapshot (kvm appears to
boot machine then apply snapshot, more like an overlay, plus file size
goes up by 1/3)

Is there a method I can use then to save a VM with its memory/file
state, clone the file, and spin up a new instance with the saved
state?

There doesn't need to be any networking an hostname is immaterial so
I'm not worried about network/hostname conflicts.

Thanks for reading and any help.
