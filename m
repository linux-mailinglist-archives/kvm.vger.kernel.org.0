Return-Path: <kvm+bounces-31658-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 273029C6192
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 20:34:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D38671F232A6
	for <lists+kvm@lfdr.de>; Tue, 12 Nov 2024 19:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF789219E49;
	Tue, 12 Nov 2024 19:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KT5ndYvM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7C9219E26
	for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 19:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731440021; cv=none; b=L6YAjTmB0bbWhwPT8YxoVQ9cfFeOGulGmfuPUH9DF5zsFojhXe2fKn03NeNJDi+olojlJ3hthEuzdC0FgMEsdkGR5C0BcDVPqGZ2FMzjkUwHtHaL7Y7D2TklpWKKFj9Hm5GuAJiEqx2uyC3oJ0iCCE8ezCFZWR7sjnFyNOrDT0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731440021; c=relaxed/simple;
	bh=2sRpzLseebI7Qfct9FG18ZAYBKUAoTH8qQjV2ey2nYY=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=BcCyYnvur2fYCaZP0OTW+X9Kw30jF5LI6S/BOl9ST0XeQjIZMQauDCIYKeLEqYZm88mJHSkYwN9jj7IuMsaVxirhgH6J+X8FLtNSXm3VMPpnGZca4AWAmyiWGc8KU6cZPEOZdwwQ9o9MpmZdZchVBZZypHWsdfLPRsDCJFAR1R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KT5ndYvM; arc=none smtp.client-ip=209.85.210.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-71e64cbb445so5907433b3a.1
        for <kvm@vger.kernel.org>; Tue, 12 Nov 2024 11:33:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731440019; x=1732044819; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2sRpzLseebI7Qfct9FG18ZAYBKUAoTH8qQjV2ey2nYY=;
        b=KT5ndYvM0tK4jbpo32+7LAd30yA7yRYKcf7OqIDmFqIb6VopgjsVgHdl1y257mY4LM
         26fe58nne/Q4fu5iO/VRLfvkr0PGjh2YplXxP6+USFSgZupZXqsUKEQKQhvKA0ta3+y+
         Klr7srG/JHTPzA3TIPBf0KbgQWwKBc5X8IBhoLpPtqGGFKk59j3cd8gALYwAjsWrN5jQ
         hbKy2+V435XlX/boINFilNwMWjMGeuEn9k+g4YwXMSA2zaeMzt0gSaGUOf7MFA6fQZaG
         MJSLFnVAB1gq60ELtQHhPvna6DHFQmNlzi1F1rNmsv5/3oOiw2UR/80Iqxeyxh1163mZ
         bWEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731440019; x=1732044819;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2sRpzLseebI7Qfct9FG18ZAYBKUAoTH8qQjV2ey2nYY=;
        b=wqV1HyRD5NtELCaFCi3RvC0/s4niN+2HEc3tbSoNqIhnoymWX0wnQKrxPHfM50v7eD
         bKlsfuKHAiDfnKLWG/VzYuQtb/6xzVFDy3ACNmlKpWYl5tXJvaTladwd6TqEcSKi86Ga
         LKKB1q/S+QUl6o1Tm581YIEPT6+Pl1ucL1NL5HD0oqVyuRYrgfbqn94fEUd11Uny6d8P
         0SE0VzU0OIL+tsf0ohHCZINQwVfsVYcvupMX8Ku0W90/Weysf/hFuXIVw501TDQfQ0kC
         DNfDQQYodJeBOpx8cREckVVYt2O6ZqHWtKRAyXkGFrYF9l7NF905aUTu8zl2l0EztiES
         K3xQ==
X-Gm-Message-State: AOJu0YxA0+cE3+CPmtD9PreZXZtb/ushME7QGVXZfYZpPVpLaxGPgqvw
	56jOelKIui7tLCIiAIwozSNLLsbIDhPdp+Y0oNgR9patBCn94AkeeLKd1V40KhsFpsaHeBKfzDE
	RNw==
X-Google-Smtp-Source: AGHT+IFxFnQk5O6XqppL9HFw/YCu7JzwmbeuSjSt85G05V+e4yOXzFuo9442/nAdDBu09BN7CI3n/e0nzW4=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:9d:3983:ac13:c240])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:859a:b0:71e:6122:d9c with SMTP id
 d2e1a72fcca58-72457aa8624mr14119b3a.4.1731440019072; Tue, 12 Nov 2024
 11:33:39 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue, 12 Nov 2024 11:33:30 -0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.47.0.277.g8800431eea-goog
Message-ID: <20241112193335.597514-1-seanjc@google.com>
Subject: [GIT PULL] KVM: x86 changes for 6.13
From: Sean Christopherson <seanjc@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"

AFAIK, there are no conflicts or dependencies with other architectures or
trees.

