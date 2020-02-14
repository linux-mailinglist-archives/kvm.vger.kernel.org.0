Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C36215D07B
	for <lists+kvm@lfdr.de>; Fri, 14 Feb 2020 04:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgBND1G (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 22:27:06 -0500
Received: from mail-pf1-f201.google.com ([209.85.210.201]:34505 "EHLO
        mail-pf1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728639AbgBND1B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 22:27:01 -0500
Received: by mail-pf1-f201.google.com with SMTP id q5so5159771pfh.1
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 19:27:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=fKf7Qy7FXarC79v0tJzZ3+R2Ba3CQFsER7P1EGsqsHY=;
        b=m8Bsd5O0fYTKXemGllMkb7FkRhDEMVPj/GtwwVndphe2KtvZwDgPMvOndFJ1Me9mR6
         qchUsPUoP5EMZyWtPHuhw/3WRcCKJ9AJpFVvSqDmZYbjLUufy2ZPyY2E1CWK6dvjq+TW
         5/FD9kOtqSSGOtpUCyyqsW5UppSVE95es/30cP5meRBUMbYnjjkHCprogKIm8kn7EnNc
         DUPF38vxu4j3W4ZB28OXlCzWb7otenUgLwLYUb7x9KbAP937VsvwyYvAUPc+BmGY4m0W
         6c3h1C3PFYeapH9/kxLyE5PkmDq3X8R+UfxQj585upTsNCWPx7ZVgF57E1OsvjcEU5Sn
         xSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=fKf7Qy7FXarC79v0tJzZ3+R2Ba3CQFsER7P1EGsqsHY=;
        b=XCXBJF+hxIsyj/v3tR/wRQ12koL2Yhu3ahMfsxP1euNEyxcmqCBMc5PByCfpcnvHkA
         5tVtqhr/k6aqZ/mm2CAOQZef6h0TWcye4CMdHH7eaKhNcw3ogFodTsUBbzc/qXixqR52
         fn7QRn1skYJHAua8FjWmlhUqSdg6EmUSus31AXE/KRWvnyTzFO7n6vKOLrMUrupfvIge
         dIffUfpi76Ce37heZOnYw4bCc/hRUUV/l88RMv1eZwQt6hBg9YF7WFTBTe0F2vFBDT7I
         HAFkykFh/aWlthOE781yoUoso/UorgVGlTsM84MPpKeGOKEYxy7XQMwC50uDMIzO8+iV
         fX+Q==
X-Gm-Message-State: APjAAAVZs7VZo0+QDibqu2Xj0VkxAS87KWfdSO+N+tqvM5Ex2WaJhhQA
        UW3FjFoaEbjFQoJy7PVlz6+oBWFjglw=
X-Google-Smtp-Source: APXvYqz2fnuE3DjoH2Z9nK9q0f7PKQ3B4Sm4/6hfEOXXSIs9x+fZJnAlRyTJsD2KVimPXLIKVGevufbrNME=
X-Received: by 2002:a63:f0a:: with SMTP id e10mr1105943pgl.402.1581650821043;
 Thu, 13 Feb 2020 19:27:01 -0800 (PST)
Date:   Thu, 13 Feb 2020 19:26:34 -0800
In-Reply-To: <20200214032635.75434-1-dancol@google.com>
Message-Id: <20200214032635.75434-3-dancol@google.com>
Mime-Version: 1.0
References: <20200211225547.235083-1-dancol@google.com> <20200214032635.75434-1-dancol@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH 2/3] Teach SELinux about anonymous inodes
From:   Daniel Colascione <dancol@google.com>
To:     timmurray@google.com, selinux@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, viro@zeniv.linux.org.uk, paul@paul-moore.com,
        nnk@google.com, sds@tycho.nsa.gov, lokeshgidra@google.com
Cc:     Daniel Colascione <dancol@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This change uses the anon_inodes and LSM infrastructure introduced in
the previous patch to give SELinux the ability to control
anonymous-inode files that are created using the new _secure()
anon_inodes functions.

A SELinux policy author detects and controls these anonymous inodes by
adding a name-based type_transition rule that assigns a new security
type to anonymous-inode files created in some domain. The name used
for the name-based transition is the name associated with the
anonymous inode for file listings --- e.g., "[userfaultfd]" or
"[perf_event]".

Example:

type uffd_t;
type_transition sysadm_t sysadm_t : file uffd_t "[userfaultfd]";
allow sysadm_t uffd_t:file { create };

(The next patch in this series is necessary for making userfaultfd
support this new interface.  The example above is just
for exposition.)

Signed-off-by: Daniel Colascione <dancol@google.com>
---
 security/selinux/hooks.c | 57 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1659b59fb5d7..6de0892620b3 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -2915,6 +2915,62 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 	return 0;
 }
 
+static int selinux_inode_init_security_anon(struct inode *inode,
+					    const struct qstr *name,
+					    const struct file_operations *fops,
+					    const struct inode *context_inode)
+{
+	const struct task_security_struct *tsec = selinux_cred(current_cred());
+	struct common_audit_data ad;
+	struct inode_security_struct *isec;
+	int rc;
+
+	if (unlikely(IS_PRIVATE(inode)))
+		return 0;
+
+	if (unlikely(!selinux_state.initialized))
+		return 0;
+
+	isec = selinux_inode(inode);
+
+	/*
+	 * We only get here once per ephemeral inode.  The inode has
+	 * been initialized via inode_alloc_security but is otherwise
+	 * untouched.
+	 */
+
+	if (context_inode) {
+		struct inode_security_struct *context_isec =
+			selinux_inode(context_inode);
+		if (IS_ERR(context_isec))
+			return PTR_ERR(context_isec);
+		isec->sid = context_isec->sid;
+	} else {
+		rc = security_transition_sid(
+			&selinux_state, tsec->sid, tsec->sid,
+			SECCLASS_FILE, name, &isec->sid);
+		if (rc)
+			return rc;
+	}
+
+	isec->initialized = LABEL_INITIALIZED;
+
+	/*
+	 * Now that we've initialized security, check whether we're
+	 * allowed to actually create this type of anonymous inode.
+	 */
+
+	ad.type = LSM_AUDIT_DATA_INODE;
+	ad.u.inode = inode;
+
+	return avc_has_perm(&selinux_state,
+			    tsec->sid,
+			    isec->sid,
+			    isec->sclass,
+			    FILE__CREATE,
+			    &ad);
+}
+
 static int selinux_inode_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	return may_create(dir, dentry, SECCLASS_FILE);
@@ -6923,6 +6979,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 
 	LSM_HOOK_INIT(inode_free_security, selinux_inode_free_security),
 	LSM_HOOK_INIT(inode_init_security, selinux_inode_init_security),
+	LSM_HOOK_INIT(inode_init_security_anon, selinux_inode_init_security_anon),
 	LSM_HOOK_INIT(inode_create, selinux_inode_create),
 	LSM_HOOK_INIT(inode_link, selinux_inode_link),
 	LSM_HOOK_INIT(inode_unlink, selinux_inode_unlink),
-- 
2.25.0.265.gbab2e86ba0-goog

